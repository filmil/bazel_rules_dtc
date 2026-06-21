"""The `dtb_decompile` rule: turn a device tree blob back into source."""

def _impl(ctx):
    out = ctx.actions.declare_file(
        ctx.attr.out if ctx.attr.out else ctx.label.name + ".dts",
    )

    args = ctx.actions.args()
    args.add("-I", "dtb")
    args.add("-O", "dts")
    args.add_all(ctx.attr.copts)
    args.add("-o", out)
    args.add(ctx.file.src)

    ctx.actions.run(
        executable = ctx.executable._dtc,
        arguments = [args],
        inputs = [ctx.file.src],
        outputs = [out],
        mnemonic = "DtcDecompile",
        progress_message = "Decompiling device tree %{label}",
    )

    return [DefaultInfo(files = depset([out]))]

dtb_decompile = rule(
    implementation = _impl,
    doc = """Decompiles a device tree blob (`.dtb`/`.dtbo`) back into a textual
device tree source (`.dts`) using `dtc -I dtb -O dts`.

Useful for round-trip tests and for inspecting compiled blobs.

Example:

```python
load("@rules_dtc//:defs.bzl", "dtc_compile", "dtb_decompile")

dtc_compile(name = "board", src = "board.dts")

dtb_decompile(
    name = "board_roundtrip",
    src = ":board",
)
```
""",
    attrs = {
        "src": attr.label(
            doc = "The device tree blob to decompile.",
            allow_single_file = [".dtb", ".dtbo"],
            mandatory = True,
        ),
        "copts": attr.string_list(
            doc = "Extra flags passed verbatim to `dtc` (e.g. `-s` to sort).",
        ),
        "out": attr.string(
            doc = "Output file name. Defaults to `<name>.dts`.",
        ),
        "_dtc": attr.label(
            default = "@dtc//:dtc",
            executable = True,
            cfg = "exec",
        ),
    },
)
