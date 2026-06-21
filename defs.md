<!-- Generated with Stardoc: http://skydoc.bazel.build -->

Public API for `rules_dtc`: Bazel rules for the Device Tree Compiler.

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

<a id="dtb_decompile"></a>

## dtb_decompile

<pre>
load("@rules_dtc//:defs.bzl", "dtb_decompile")

dtb_decompile(<a href="#dtb_decompile-name">name</a>, <a href="#dtb_decompile-src">src</a>, <a href="#dtb_decompile-out">out</a>, <a href="#dtb_decompile-copts">copts</a>)
</pre>

Decompiles a device tree blob (`.dtb`/`.dtbo`) back into a textual
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

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="dtb_decompile-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="dtb_decompile-src"></a>src |  The device tree blob to decompile.   | <a href="https://bazel.build/concepts/labels">Label</a> | required |  |
| <a id="dtb_decompile-out"></a>out |  Output file name. Defaults to `<name>.dts`.   | String | optional |  `""`  |
| <a id="dtb_decompile-copts"></a>copts |  Extra flags passed verbatim to `dtc` (e.g. `-s` to sort).   | List of strings | optional |  `[]`  |


<a id="dtbo_compile"></a>

## dtbo_compile

<pre>
load("@rules_dtc//:defs.bzl", "dtbo_compile")

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


<a id="dtc_compile"></a>

## dtc_compile

<pre>
load("@rules_dtc//:defs.bzl", "dtc_compile")

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


<a id="dts_library"></a>

## dts_library

<pre>
load("@rules_dtc//:defs.bzl", "dts_library")

dts_library(<a href="#dts_library-name">name</a>, <a href="#dts_library-deps">deps</a>, <a href="#dts_library-srcs">srcs</a>, <a href="#dts_library-includes">includes</a>)
</pre>

Groups device tree include files (`.dtsi`, `.dts`, `.h`) so they can
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

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="dts_library-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="dts_library-deps"></a>deps |  Other `dts_library` targets this library depends on.   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="dts_library-srcs"></a>srcs |  Device tree include/source files exposed by this library.   | <a href="https://bazel.build/concepts/labels">List of labels</a> | required |  |
| <a id="dts_library-includes"></a>includes |  Extra include directories, relative to this package.   | List of strings | optional |  `[]`  |


<a id="dts_test"></a>

## dts_test

<pre>
load("@rules_dtc//:defs.bzl", "dts_test")

dts_test(<a href="#dts_test-name">name</a>, <a href="#dts_test-dtb">dtb</a>, <a href="#dts_test-dump">dump</a>, <a href="#dts_test-properties">properties</a>)
</pre>

Asserts that a compiled device tree blob contains the expected
property values, using `fdtget`. Optionally dumps the blob with `fdtdump`.

Each entry in `properties` maps a `"node|property"` key to its expected
(string) value as printed by `fdtget`.

Example:

```python
load("@rules_dtc//:defs.bzl", "dtc_compile", "dts_test")

dtc_compile(name = "board", src = "board.dts")

dts_test(
    name = "board_test",
    dtb = ":board",
    properties = {
        "/|compatible": "acme,board",
        "/cpus/cpu@0|device_type": "cpu",
    },
    dump = True,
)
```

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="dts_test-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="dts_test-dtb"></a>dtb |  The device tree blob to inspect.   | <a href="https://bazel.build/concepts/labels">Label</a> | required |  |
| <a id="dts_test-dump"></a>dump |  Also run `fdtdump` on the blob as a smoke check.   | Boolean | optional |  `False`  |
| <a id="dts_test-properties"></a>properties |  Map of `"node\|property"` to the expected `fdtget` output.   | <a href="https://bazel.build/rules/lib/core/dict">Dictionary: String -> String</a> | optional |  `{}`  |


<a id="fdt_overlay"></a>

## fdt_overlay

<pre>
load("@rules_dtc//:defs.bzl", "fdt_overlay")

fdt_overlay(<a href="#fdt_overlay-name">name</a>, <a href="#fdt_overlay-out">out</a>, <a href="#fdt_overlay-base">base</a>, <a href="#fdt_overlay-overlays">overlays</a>)
</pre>

Applies one or more device tree overlays (`.dtbo`) onto a base
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

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="fdt_overlay-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="fdt_overlay-out"></a>out |  Output file name. Defaults to `<name>.dtb`.   | String | optional |  `""`  |
| <a id="fdt_overlay-base"></a>base |  Base device tree blob (compiled with `symbols = True`).   | <a href="https://bazel.build/concepts/labels">Label</a> | required |  |
| <a id="fdt_overlay-overlays"></a>overlays |  Overlay blobs (`.dtbo`) to apply, in order.   | <a href="https://bazel.build/concepts/labels">List of labels</a> | required |  |


<a id="DtsInfo"></a>

## DtsInfo

<pre>
load("@rules_dtc//:defs.bzl", "DtsInfo")

DtsInfo(<a href="#DtsInfo-transitive_srcs">transitive_srcs</a>, <a href="#DtsInfo-transitive_includes">transitive_includes</a>)
</pre>

Information about a collection of device tree source files.

**FIELDS**

| Name  | Description |
| :------------- | :------------- |
| <a id="DtsInfo-transitive_srcs"></a>transitive_srcs |  depset of File: all `.dts`/`.dtsi`/header files that may be referenced via `/include/` or `#include`.    |
| <a id="DtsInfo-transitive_includes"></a>transitive_includes |  depset of string: include search directories (passed to `dtc -i` and to the C preprocessor).    |


