"""Providers shared by the device tree rules."""

DtsInfo = provider(
    doc = "Information about a collection of device tree source files.",
    fields = {
        "transitive_srcs": "depset of File: all `.dts`/`.dtsi`/header files " +
                           "that may be referenced via `/include/` or `#include`.",
        "transitive_includes": "depset of string: include search directories " +
                               "(passed to `dtc -i` and to the C preprocessor).",
    },
)
