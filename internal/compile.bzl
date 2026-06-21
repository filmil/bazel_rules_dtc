"""Shared implementation for compiling device tree sources with `dtc`.

This module is internal. Public rules `dtc_compile` and `dtbo_compile` reuse the
implementation and attributes defined here.
"""

load("@bazel_skylib//lib:paths.bzl", "paths")
load(":providers.bzl", "DtsInfo")

# The C/C++ toolchain type, used to resolve the preprocessor for the optional
# `preprocess = True` mode.
_CC_TOOLCHAIN_TYPE = "@bazel_tools//tools/cpp:toolchain_type"

# Attributes shared by `dtc_compile` and `dtbo_compile`.
DTC_COMPILE_ATTRS = {
    "src": attr.label(
        doc = "The top-level `.dts` device tree source to compile.",
        allow_single_file = [".dts", ".dtsi"],
        mandatory = True,
    ),
    "deps": attr.label_list(
        doc = "`dts_library` targets whose sources are reachable via " +
              "`/include/` or `#include`.",
        providers = [DtsInfo],
    ),
    "includes": attr.string_list(
        doc = "Additional include directories, relative to this package, " +
              "added to the `dtc -i` and preprocessor search paths.",
    ),
    "symbols": attr.bool(
        doc = "Emit a `__symbols__` node (`dtc -@`). Required for base blobs " +
              "that overlays are applied to.",
        default = False,
    ),
    "preprocess": attr.bool(
        doc = "Run the C preprocessor (via the cc toolchain) before `dtc`. " +
              "Enables `#include`, `#define` and macros (Linux-kernel style).",
        default = False,
    ),
    "defines": attr.string_list(
        doc = "C preprocessor `-D` defines. Only used when `preprocess = True`.",
    ),
    "cpp_includes": attr.label_list(
        doc = "Extra header files (e.g. `.h`) made available to the C " +
              "preprocessor when `preprocess = True`.",
        allow_files = True,
    ),
    "copts": attr.string_list(
        doc = "Extra command line flags passed verbatim to `dtc` " +
              "(e.g. `-W no-unit_address_vs_reg`).",
    ),
    "out": attr.string(
        doc = "Output file name. Defaults to `<name>.dtb` (or `.dtbo`).",
    ),
    "_dtc": attr.label(
        default = "@dtc//:dtc",
        executable = True,
        cfg = "exec",
    ),
}

def _package_dir(ctx, sub):
    if ctx.label.package:
        return paths.normalize(paths.join(ctx.label.package, sub))
    return paths.normalize(sub) if sub else "."

def _collect(ctx):
    """Returns (include_dirs list, transitive source depset)."""
    direct_dirs = [ctx.file.src.dirname]
    for inc in ctx.attr.includes:
        direct_dirs.append(_package_dir(ctx, inc))

    transitive_incs = []
    transitive_srcs = []
    for dep in ctx.attr.deps:
        info = dep[DtsInfo]
        transitive_incs.append(info.transitive_includes)
        transitive_srcs.append(info.transitive_srcs)

    include_dirs = depset(
        direct = direct_dirs,
        transitive = transitive_incs,
    ).to_list()
    srcs = depset(transitive = transitive_srcs)
    return include_dirs, srcs

def _cc_toolchain(ctx):
    # Mirrors what find_cpp_toolchain() does, but without an extra .bzl load.
    info = ctx.toolchains[_CC_TOOLCHAIN_TYPE]
    if hasattr(info, "cc"):
        return info.cc
    return info

def _preprocess(ctx, src, include_dirs):
    cc_toolchain = _cc_toolchain(ctx)
    out = ctx.actions.declare_file(ctx.label.name + ".pp.dts")

    args = ctx.actions.args()
    args.add("-E")
    args.add("-nostdinc")
    args.add("-undef")
    args.add("-D__DTS__")
    args.add("-x", "assembler-with-cpp")
    for d in ctx.attr.defines:
        args.add("-D" + d)
    for inc in include_dirs:
        args.add("-I", inc)
    args.add("-o", out)
    args.add(src)

    ctx.actions.run(
        executable = cc_toolchain.compiler_executable,
        arguments = [args],
        inputs = depset(
            direct = [src] + ctx.files.cpp_includes,
            transitive = [cc_toolchain.all_files],
        ),
        outputs = [out],
        mnemonic = "DtsPreprocess",
        progress_message = "Preprocessing device tree %{label}",
    )
    return out

def dtc_compile_impl(ctx, out_extension, force_symbols):
    """Compiles `ctx.attr.src` to a device tree blob.

    Args:
      ctx: the rule context.
      out_extension: output extension, e.g. ".dtb" or ".dtbo".
      force_symbols: if True, always pass `dtc -@` regardless of the attribute.

    Returns:
      A list of providers (DefaultInfo with the compiled blob).
    """
    include_dirs, dep_srcs = _collect(ctx)

    out_name = ctx.attr.out if ctx.attr.out else ctx.label.name + out_extension
    out = ctx.actions.declare_file(out_name)

    src = ctx.file.src
    extra_inputs = dep_srcs
    if ctx.attr.preprocess:
        src = _preprocess(ctx, src, include_dirs)

    args = ctx.actions.args()
    args.add("-I", "dts")
    args.add("-O", "dtb")
    if force_symbols or ctx.attr.symbols:
        args.add("-@")
    for inc in include_dirs:
        args.add("-i", inc)
    args.add_all(ctx.attr.copts)
    args.add("-o", out)
    args.add(src)

    ctx.actions.run(
        executable = ctx.executable._dtc,
        arguments = [args],
        inputs = depset(direct = [src], transitive = [extra_inputs]),
        outputs = [out],
        mnemonic = "Dtc",
        progress_message = "Compiling device tree %{label}",
    )

    return [DefaultInfo(files = depset([out]))]

# Toolchains required by the compile rules (for the optional preprocessor).
DTC_COMPILE_TOOLCHAINS = [_CC_TOOLCHAIN_TYPE]
