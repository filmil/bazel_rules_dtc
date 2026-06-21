<!-- Generated with Stardoc: http://skydoc.bazel.build -->

The `dtc_compile` rule: compile a device tree source into a `.dtb` blob.

<a id="dtc_compile"></a>

## dtc_compile

<pre>
load("@rules_dtc//internal:dtc_compile.bzl", "dtc_compile")

dtc_compile(<a href="#dtc_compile-name">name</a>, <a href="#dtc_compile-deps">deps</a>, <a href="#dtc_compile-src">src</a>, <a href="#dtc_compile-out">out</a>, <a href="#dtc_compile-copts">copts</a>, <a href="#dtc_compile-cpp_includes">cpp_includes</a>, <a href="#dtc_compile-defines">defines</a>, <a href="#dtc_compile-includes">includes</a>, <a href="#dtc_compile-preprocess">preprocess</a>, <a href="#dtc_compile-symbols">symbols</a>)
</pre>

Compiles a device tree source (`.dts`) into a flattened device tree
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

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="dtc_compile-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="dtc_compile-deps"></a>deps |  `dts_library` targets whose sources are reachable via `/include/` or `#include`.   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="dtc_compile-src"></a>src |  The top-level `.dts` device tree source to compile.   | <a href="https://bazel.build/concepts/labels">Label</a> | required |  |
| <a id="dtc_compile-out"></a>out |  Output file name. Defaults to `<name>.dtb` (or `.dtbo`).   | String | optional |  `""`  |
| <a id="dtc_compile-copts"></a>copts |  Extra command line flags passed verbatim to `dtc` (e.g. `-W no-unit_address_vs_reg`).   | List of strings | optional |  `[]`  |
| <a id="dtc_compile-cpp_includes"></a>cpp_includes |  Extra header files (e.g. `.h`) made available to the C preprocessor when `preprocess = True`.   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="dtc_compile-defines"></a>defines |  C preprocessor `-D` defines. Only used when `preprocess = True`.   | List of strings | optional |  `[]`  |
| <a id="dtc_compile-includes"></a>includes |  Additional include directories, relative to this package, added to the `dtc -i` and preprocessor search paths.   | List of strings | optional |  `[]`  |
| <a id="dtc_compile-preprocess"></a>preprocess |  Run the C preprocessor (via the cc toolchain) before `dtc`. Enables `#include`, `#define` and macros (Linux-kernel style).   | Boolean | optional |  `False`  |
| <a id="dtc_compile-symbols"></a>symbols |  Emit a `__symbols__` node (`dtc -@`). Required for base blobs that overlays are applied to.   | Boolean | optional |  `False`  |


