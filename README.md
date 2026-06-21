# bazel_rules_dtc: Device Tree Compiler rules for Bazel

[![Test](https://github.com/filmil/bazel_rules_dtc/actions/workflows/test.yml/badge.svg)](https://github.com/filmil/bazel_rules_dtc/actions/workflows/test.yml)
[![Publish to my Bazel registry](https://github.com/filmil/bazel_rules_dtc/actions/workflows/publish.yml/badge.svg)](https://github.com/filmil/bazel_rules_dtc/actions/workflows/publish.yml)
[![Publish on Bazel Central Registry](https://github.com/filmil/bazel_rules_dtc/actions/workflows/publish-bcr.yml/badge.svg)](https://github.com/filmil/bazel_rules_dtc/actions/workflows/publish-bcr.yml)
[![Tag and Release](https://github.com/filmil/bazel_rules_dtc/actions/workflows/tag-and-release.yml/badge.svg)](https://github.com/filmil/bazel_rules_dtc/actions/workflows/tag-and-release.yml)

## Overview

`bazel_rules_dtc` provides Bazel rules for the [Device Tree Compiler][dtc]
(`dtc`). It lets you compile device tree sources (`.dts`) into flattened device
tree blobs (`.dtb`), build and apply device tree overlays (`.dtbo`), decompile
blobs back into sources, and assert properties of the result — all as hermetic
Bazel actions.

The rules drive the `dtc`, `fdtoverlay`, `fdtget` and `fdtdump` binaries
provided by the [`dtc`][dtc-bcr] module in the Bazel Central Registry, so no
host installation of the device tree compiler is required.

Both styles of device tree inclusion are supported:

* native dtc `/include/` directives, resolved from `dts_library` include
  directories; and
* C-preprocessor `#include` / `#define` (Linux-kernel style), enabled per
  target with `preprocess = True` (uses the cc toolchain's preprocessor).

[dtc]: https://git.kernel.org/pub/scm/utils/dtc/dtc.git
[dtc-bcr]: https://registry.bazel.build/modules/dtc

## Installation

This module is published to a personal Bazel registry (and, where appropriate,
to the Bazel Central Registry). To use the personal registry, add it to your
`.bazelrc`:

```
common --registry=https://bcr.bazel.build
common --registry=https://raw.githubusercontent.com/filmil/bazel-registry/main
```

Then depend on it from your `MODULE.bazel`:

```python
bazel_dep(name = "rules_dtc", version = "0.0.0")  # use the latest version
```

> Note: adding a custom registry replaces the default BCR entry, so the BCR
> registry must be listed explicitly as shown above.

## Documentation

The API reference below is generated from the rule sources with
[Stardoc][stardoc] and kept in sync with `bazel run //:update`.

| File | Documentation | Description |
| :--- | :--- | :--- |
| `defs.bzl` | [defs.md](defs.md) | Public API: all rules, loaded from `@rules_dtc//:defs.bzl` |
| `internal/dts_library.bzl` | [internal/dts_library.md](internal/dts_library.md) | `dts_library`: a reusable collection of device tree includes |
| `internal/dtc_compile.bzl` | [internal/dtc_compile.md](internal/dtc_compile.md) | `dtc_compile`: compile a `.dts` into a `.dtb` |
| `internal/dtbo_compile.bzl` | [internal/dtbo_compile.md](internal/dtbo_compile.md) | `dtbo_compile`: compile a device tree overlay into a `.dtbo` |
| `internal/fdt_overlay.bzl` | [internal/fdt_overlay.md](internal/fdt_overlay.md) | `fdt_overlay`: apply overlays onto a base blob |
| `internal/dtb_decompile.bzl` | [internal/dtb_decompile.md](internal/dtb_decompile.md) | `dtb_decompile`: decompile a `.dtb` back into a `.dts` |
| `internal/dts_test.bzl` | [internal/dts_test.md](internal/dts_test.md) | `dts_test`: assert blob properties via `fdtget`/`fdtdump` |
| `internal/providers.bzl` | [internal/providers.md](internal/providers.md) | `DtsInfo`: provider exposing transitive sources and include dirs |
| `internal/compile.bzl` | [internal/compile.md](internal/compile.md) | Shared implementation for the compile rules |

[stardoc]: https://github.com/bazelbuild/stardoc

## Usage

Load the rules from `@rules_dtc//:defs.bzl`.

### Compile a device tree

```python
load("@rules_dtc//:defs.bzl", "dtc_compile")

dtc_compile(
    name = "board",
    src = "board.dts",
)
```

### Reusable includes with `dts_library`

```python
load("@rules_dtc//:defs.bzl", "dtc_compile", "dts_library")

dts_library(
    name = "soc",
    srcs = ["soc.dtsi"],
)

dtc_compile(
    name = "board",
    src = "board.dts",   # uses /include/ "soc.dtsi"
    deps = [":soc"],
)
```

### C-preprocessor (kernel-style sources)

```python
load("@rules_dtc//:defs.bzl", "dtc_compile")

dtc_compile(
    name = "board",
    src = "board.dts",        # uses #include "regs.h" and macros
    preprocess = True,
    cpp_includes = ["regs.h"],
    defines = ["CLOCK_FREQ=24000000"],
)
```

### Overlays

```python
load("@rules_dtc//:defs.bzl", "dtc_compile", "dtbo_compile", "fdt_overlay")

dtc_compile(name = "base", src = "base.dts", symbols = True)
dtbo_compile(name = "uart", src = "uart_overlay.dts")

fdt_overlay(
    name = "merged",
    base = ":base",
    overlays = [":uart"],
)
```

### Asserting properties

```python
load("@rules_dtc//:defs.bzl", "dts_test")

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

## Examples

The `//integration` directory is a self-contained Bazel module with 15 worked
examples, each exercising one or more rules — from a minimal compile to nested
includes, shared SoC descriptions, overlays (single and stacked), preprocessor
usage, phandles and `reserved-memory`, and `fdtget`/`fdtdump` assertions. Build
and test them with:

```bash
cd integration
bazel build //...
bazel test //...
```

## Contributing

Contributions are welcome. Please open an issue to discuss substantial changes
before submitting a pull request. When you change a rule's public API, run
`bazel run //:update` to regenerate the documentation and commit the result.

## License

This project is licensed under the Apache License 2.0. See [LICENSE](LICENSE)
for the full text.
