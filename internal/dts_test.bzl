"""The `dts_test` rule: assert properties of a compiled device tree blob."""

load(":dts_test_tpl.bzl", "DTS_TEST_TEMPLATE")

def _rlocationpath(file, workspace_name):
    # Runfiles path used by `rlocation`. Files from external repositories have a
    # short_path of the form `../<repo>/<path>`.
    if file.short_path.startswith("../"):
        return file.short_path[len("../"):]
    return workspace_name + "/" + file.short_path

def _impl(ctx):
    script = ctx.actions.declare_file(ctx.label.name + ".sh")

    assertions = []
    for key, want in ctx.attr.properties.items():
        if "|" not in key:
            fail("dts_test 'properties' keys must be 'node|property', got: " + key)
        node, _, prop = key.partition("|")
        assertions.append(
            "check {node} {prop} {want}".format(
                node = repr(node),
                prop = repr(prop),
                want = repr(want),
            ),
        )

    content = DTS_TEST_TEMPLATE
    content = content.replace("%FDTGET%", _rlocationpath(ctx.executable._fdtget, ctx.workspace_name))
    content = content.replace("%FDTDUMP%", _rlocationpath(ctx.executable._fdtdump, ctx.workspace_name))
    content = content.replace("%DTB%", _rlocationpath(ctx.file.dtb, ctx.workspace_name))
    content = content.replace("%ASSERTIONS%", "\n".join(assertions))
    content = content.replace("%DUMP%", "dump" if ctx.attr.dump else "")

    ctx.actions.write(output = script, content = content, is_executable = True)

    runfiles = ctx.runfiles(files = [ctx.file.dtb])
    runfiles = runfiles.merge_all([
        ctx.attr._fdtget[DefaultInfo].default_runfiles,
        ctx.attr._fdtdump[DefaultInfo].default_runfiles,
        ctx.attr._runfiles_lib[DefaultInfo].default_runfiles,
    ])

    return [DefaultInfo(executable = script, runfiles = runfiles)]

dts_test = rule(
    implementation = _impl,
    test = True,
    doc = """Asserts that a compiled device tree blob contains the expected
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
""",
    attrs = {
        "dtb": attr.label(
            doc = "The device tree blob to inspect.",
            allow_single_file = [".dtb", ".dtbo"],
            mandatory = True,
        ),
        "properties": attr.string_dict(
            doc = "Map of `\"node|property\"` to the expected `fdtget` output.",
        ),
        "dump": attr.bool(
            doc = "Also run `fdtdump` on the blob as a smoke check.",
            default = False,
        ),
        "_fdtget": attr.label(
            default = "@dtc//:fdtget",
            executable = True,
            cfg = "target",
        ),
        "_fdtdump": attr.label(
            default = "@dtc//:fdtdump",
            executable = True,
            cfg = "target",
        ),
        "_runfiles_lib": attr.label(
            default = "@bazel_tools//tools/bash/runfiles",
        ),
    },
)
