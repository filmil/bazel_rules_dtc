<!-- Generated with Stardoc: http://skydoc.bazel.build -->

The `dtb_decompile` rule: turn a device tree blob back into source.

<a id="dtb_decompile"></a>

## dtb_decompile

<pre>
load("@rules_dtc//internal:dtb_decompile.bzl", "dtb_decompile")

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


