"""The `dts_library` rule: a reusable collection of device tree includes."""

load("@bazel_skylib//lib:paths.bzl", "paths")
load(":providers.bzl", "DtsInfo")

def _impl(ctx):
    direct_srcs = ctx.files.srcs

    direct_dirs = [f.dirname for f in direct_srcs]
    for inc in ctx.attr.includes:
        if ctx.label.package:
            direct_dirs.append(paths.normalize(paths.join(ctx.label.package, inc)))
        else:
            direct_dirs.append(paths.normalize(inc))

    transitive_srcs = []
    transitive_incs = []
    for dep in ctx.attr.deps:
        info = dep[DtsInfo]
        transitive_srcs.append(info.transitive_srcs)
        transitive_incs.append(info.transitive_includes)

    srcs = depset(direct = direct_srcs, transitive = transitive_srcs)
    incs = depset(direct = direct_dirs, transitive = transitive_incs)

    return [
        DefaultInfo(files = srcs),
        DtsInfo(transitive_srcs = srcs, transitive_includes = incs),
    ]

dts_library = rule(
    implementation = _impl,
    doc = """Groups device tree include files (`.dtsi`, `.dts`, `.h`) so they can
be reused across multiple compilations.

A `dts_library` does not run `dtc`; it only collects the source files and their
directories into a `DtsInfo` provider. Directories of the listed `srcs` are
automatically added to the include search path, so a consumer can reference them
with `/include/ "file.dtsi"` (dtc) or `#include "file.h"` (preprocessor).

Example:

```python
load("@rules_dtc//:defs.bzl", "dts_library")

dts_library(
    name = "common",
    srcs = ["gpio.dtsi", "clocks.dtsi"],
)
```
""",
    attrs = {
        "srcs": attr.label_list(
            doc = "Device tree include/source files exposed by this library.",
            allow_files = [".dts", ".dtsi", ".h"],
            mandatory = True,
        ),
        "deps": attr.label_list(
            doc = "Other `dts_library` targets this library depends on.",
            providers = [DtsInfo],
        ),
        "includes": attr.string_list(
            doc = "Extra include directories, relative to this package.",
        ),
    },
)
