<!-- Generated with Stardoc: http://skydoc.bazel.build -->

The `dtbo_compile` rule: compile a device tree overlay into a `.dtbo` blob.

<a id="dtbo_compile"></a>

## dtbo_compile

<pre>
load("@rules_dtc//internal:dtbo_compile.bzl", "dtbo_compile")

dtbo_compile(<a href="#dtbo_compile-name">name</a>, <a href="#dtbo_compile-deps">deps</a>, <a href="#dtbo_compile-src">src</a>, <a href="#dtbo_compile-out">out</a>, <a href="#dtbo_compile-copts">copts</a>, <a href="#dtbo_compile-cpp_includes">cpp_includes</a>, <a href="#dtbo_compile-defines">defines</a>, <a href="#dtbo_compile-includes">includes</a>, <a href="#dtbo_compile-preprocess">preprocess</a>, <a href="#dtbo_compile-symbols">symbols</a>)
</pre>

Compiles a device tree overlay source (`.dts`) into an overlay blob
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

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="dtbo_compile-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="dtbo_compile-deps"></a>deps |  `dts_library` targets whose sources are reachable via `/include/` or `#include`.   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="dtbo_compile-src"></a>src |  The top-level `.dts` device tree source to compile.   | <a href="https://bazel.build/concepts/labels">Label</a> | required |  |
| <a id="dtbo_compile-out"></a>out |  Output file name. Defaults to `<name>.dtb` (or `.dtbo`).   | String | optional |  `""`  |
| <a id="dtbo_compile-copts"></a>copts |  Extra command line flags passed verbatim to `dtc` (e.g. `-W no-unit_address_vs_reg`).   | List of strings | optional |  `[]`  |
| <a id="dtbo_compile-cpp_includes"></a>cpp_includes |  Extra header files (e.g. `.h`) made available to the C preprocessor when `preprocess = True`.   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="dtbo_compile-defines"></a>defines |  C preprocessor `-D` defines. Only used when `preprocess = True`.   | List of strings | optional |  `[]`  |
| <a id="dtbo_compile-includes"></a>includes |  Additional include directories, relative to this package, added to the `dtc -i` and preprocessor search paths.   | List of strings | optional |  `[]`  |
| <a id="dtbo_compile-preprocess"></a>preprocess |  Run the C preprocessor (via the cc toolchain) before `dtc`. Enables `#include`, `#define` and macros (Linux-kernel style).   | Boolean | optional |  `False`  |
| <a id="dtbo_compile-symbols"></a>symbols |  Emit a `__symbols__` node (`dtc -@`). Required for base blobs that overlays are applied to.   | Boolean | optional |  `False`  |


