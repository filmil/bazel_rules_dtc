<!-- Generated with Stardoc: http://skydoc.bazel.build -->

Providers shared by the device tree rules.

<a id="DtsInfo"></a>

## DtsInfo

<pre>
load("@rules_dtc//internal:providers.bzl", "DtsInfo")

DtsInfo(<a href="#DtsInfo-transitive_srcs">transitive_srcs</a>, <a href="#DtsInfo-transitive_includes">transitive_includes</a>)
</pre>

Information about a collection of device tree source files.

**FIELDS**

| Name  | Description |
| :------------- | :------------- |
| <a id="DtsInfo-transitive_srcs"></a>transitive_srcs |  depset of File: all `.dts`/`.dtsi`/header files that may be referenced via `/include/` or `#include`.    |
| <a id="DtsInfo-transitive_includes"></a>transitive_includes |  depset of string: include search directories (passed to `dtc -i` and to the C preprocessor).    |


