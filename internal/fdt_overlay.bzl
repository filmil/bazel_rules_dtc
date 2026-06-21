"""The `fdt_overlay` rule: apply device tree overlays onto a base blob."""

def _impl(ctx):
    out = ctx.actions.declare_file(
        ctx.attr.out if ctx.attr.out else ctx.label.name + ".dtb",
    )

    args = ctx.actions.args()
    args.add("-i", ctx.file.base)
    args.add("-o", out)
    args.add_all(ctx.files.overlays)

    ctx.actions.run(
        executable = ctx.executable._fdtoverlay,
        arguments = [args],
        inputs = [ctx.file.base] + ctx.files.overlays,
        outputs = [out],
        mnemonic = "FdtOverlay",
        progress_message = "Applying device tree overlays %{label}",
    )

    return [DefaultInfo(files = depset([out]))]

fdt_overlay = rule(
    implementation = _impl,
    doc = """Applies one or more device tree overlays (`.dtbo`) onto a base
device tree blob (`.dtb`) using `fdtoverlay`, producing a merged `.dtb`.

The base blob must have been compiled with `symbols = True` (i.e. `dtc -@`).
Overlays are applied left to right.

Example:

```python
load("@rules_dtc//:defs.bzl", "dtc_compile", "dtbo_compile", "fdt_overlay")

dtc_compile(name = "base", src = "base.dts", symbols = True)
dtbo_compile(name = "uart", src = "uart.dts")

fdt_overlay(
    name = "merged",
    base = ":base",
    overlays = [":uart"],
)
```
""",
    attrs = {
        "base": attr.label(
            doc = "Base device tree blob (compiled with `symbols = True`).",
            allow_single_file = [".dtb"],
            mandatory = True,
        ),
        "overlays": attr.label_list(
            doc = "Overlay blobs (`.dtbo`) to apply, in order.",
            allow_files = [".dtbo", ".dtb"],
            mandatory = True,
        ),
        "out": attr.string(
            doc = "Output file name. Defaults to `<name>.dtb`.",
        ),
        "_fdtoverlay": attr.label(
            default = "@dtc//:fdtoverlay",
            executable = True,
            cfg = "exec",
        ),
    },
)
