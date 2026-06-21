<!-- Generated with Stardoc: http://skydoc.bazel.build -->

The `fdt_overlay` rule: apply device tree overlays onto a base blob.

<a id="fdt_overlay"></a>

## fdt_overlay

<pre>
load("@rules_dtc//internal:fdt_overlay.bzl", "fdt_overlay")

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


