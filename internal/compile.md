<!-- Generated with Stardoc: http://skydoc.bazel.build -->

Shared implementation for compiling device tree sources with `dtc`.

This module is internal. Public rules `dtc_compile` and `dtbo_compile` reuse the
implementation and attributes defined here.

<a id="dtc_compile_impl"></a>

## dtc_compile_impl

<pre>
load("@rules_dtc//internal:compile.bzl", "dtc_compile_impl")

dtc_compile_impl(<a href="#dtc_compile_impl-ctx">ctx</a>, <a href="#dtc_compile_impl-out_extension">out_extension</a>, <a href="#dtc_compile_impl-force_symbols">force_symbols</a>)
</pre>

Compiles `ctx.attr.src` to a device tree blob.

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="dtc_compile_impl-ctx"></a>ctx |  the rule context.   |  none |
| <a id="dtc_compile_impl-out_extension"></a>out_extension |  output extension, e.g. ".dtb" or ".dtbo".   |  none |
| <a id="dtc_compile_impl-force_symbols"></a>force_symbols |  if True, always pass `dtc -@` regardless of the attribute.   |  none |

**RETURNS**

A list of providers (DefaultInfo with the compiled blob).


