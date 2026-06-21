<!-- Generated with Stardoc: http://skydoc.bazel.build -->

The `dts_test` rule: assert properties of a compiled device tree blob.

<a id="dts_test"></a>

## dts_test

<pre>
load("@rules_dtc//internal:dts_test.bzl", "dts_test")

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


