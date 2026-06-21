"""The `dtbo_compile` rule: compile a device tree overlay into a `.dtbo` blob."""

load(
    ":compile.bzl",
    "DTC_COMPILE_ATTRS",
    "DTC_COMPILE_TOOLCHAINS",
    "dtc_compile_impl",
)

def _impl(ctx):
    # Overlays always need the `__symbols__`/`__fixups__` machinery (dtc -@).
    return dtc_compile_impl(ctx, out_extension = ".dtbo", force_symbols = True)

dtbo_compile = rule(
    implementation = _impl,
    doc = """Compiles a device tree overlay source (`.dts`) into an overlay blob
(`.dtbo`) using `dtc -@`.

The resulting `.dtbo` can be applied to a base `.dtb` (itself compiled with
`symbols = True`) using `fdt_overlay`.

Example:

```python
load("@rules_dtc//:defs.bzl", "dtbo_compile")

dtbo_compile(
    name = "uart_overlay",
    src = "uart_overlay.dts",
)
```
""",
    attrs = DTC_COMPILE_ATTRS,
    toolchains = DTC_COMPILE_TOOLCHAINS,
)
