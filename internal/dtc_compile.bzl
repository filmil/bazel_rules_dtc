"""The `dtc_compile` rule: compile a device tree source into a `.dtb` blob."""

load(
    ":compile.bzl",
    "DTC_COMPILE_ATTRS",
    "DTC_COMPILE_TOOLCHAINS",
    "dtc_compile_impl",
)

def _impl(ctx):
    return dtc_compile_impl(ctx, out_extension = ".dtb", force_symbols = False)

dtc_compile = rule(
    implementation = _impl,
    doc = """Compiles a device tree source (`.dts`) into a flattened device tree
blob (`.dtb`) using `dtc`.

Sources reachable through `/include/` (or `#include` when `preprocess = True`)
are supplied through `dts_library` targets listed in `deps`.

Example:

```python
load("@rules_dtc//:defs.bzl", "dtc_compile", "dts_library")

dts_library(
    name = "soc",
    srcs = ["soc.dtsi"],
)

dtc_compile(
    name = "board",
    src = "board.dts",
    deps = [":soc"],
)
```
""",
    attrs = DTC_COMPILE_ATTRS,
    toolchains = DTC_COMPILE_TOOLCHAINS,
)
