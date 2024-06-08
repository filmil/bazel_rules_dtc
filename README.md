# bazel_rules_dtc: devicetree compiler build rules. [![Build status](https://github.com/filmil/bazel_rules_dtc/workflows/Build/badge.svg)](https://github.com/filmil/bazel_rules_dtc/workflows/Build/badge.svg)

# Contributor guide

## Prerequisites

You **must** ensure that the following steps are complete before attempting
to do any of the steps further in this document, **including** checking the
source out.

* build environment (REQUIRED)

  Install the needed prerequisites by downloading and running
  [`scripts/install_deps.sh`][id].

* `bazelisk`: https://bazel.build/install/bazelisk (REQUIRED)

  Install and make it available in your `$PATH` as `bazel`. This is what the
  rest of the examples in this README.md are assuming.

  Bazelisk automatically uses the correct `bazel` version for your build.
  Sadly, `bazel` binaries are mutually incompatible across major releases,
  which makes it hard to select the correct one yourself.

The rest of `README.md` assumes that all above prerequisites are present.

# Test

```
bazel test //build/tests/...
```

