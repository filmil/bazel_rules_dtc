"""Public API for `rules_dtc`: Bazel rules for the Device Tree Compiler.

Load rules from this file:

```python
load(
    "@rules_dtc//:defs.bzl",
    "dts_library",
    "dtc_compile",
    "dtbo_compile",
    "fdt_overlay",
    "dtb_decompile",
    "dts_test",
)
```
"""

load("//internal:dtb_decompile.bzl", _dtb_decompile = "dtb_decompile")
load("//internal:dtbo_compile.bzl", _dtbo_compile = "dtbo_compile")
load("//internal:dtc_compile.bzl", _dtc_compile = "dtc_compile")
load("//internal:dts_library.bzl", _dts_library = "dts_library")
load("//internal:dts_test.bzl", _dts_test = "dts_test")
load("//internal:fdt_overlay.bzl", _fdt_overlay = "fdt_overlay")
load("//internal:providers.bzl", _DtsInfo = "DtsInfo")

dts_library = _dts_library
dtc_compile = _dtc_compile
dtbo_compile = _dtbo_compile
fdt_overlay = _fdt_overlay
dtb_decompile = _dtb_decompile
dts_test = _dts_test
DtsInfo = _DtsInfo
