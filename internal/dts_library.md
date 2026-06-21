<!-- Generated with Stardoc: http://skydoc.bazel.build -->

The `dts_library` rule: a reusable collection of device tree includes.

<a id="dts_library"></a>

## dts_library

<pre>
load("@rules_dtc//internal:dts_library.bzl", "dts_library")

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


