def _device_tree_blob(ctx):
    dtc_path = ctx.attr._device_tree_compiler.files.to_list()[0]
    out = ctx.actions.declare_file(ctx.label.name + ctx.attr.ext)

    top_file = ctx.attr.top_level.files.to_list()[0]

    all_target_files = []
    candidates = [targets.files.to_list() for targets in ctx.attr.srcs]
    for target_files in candidates:
        all_target_files += target_files

    all_input_files = [
        file for file in all_target_files
    ]

    include_dir_list = [
        file.dirname for file in all_target_files if file.extension == 'dtsi' ]

    # Make the dir list unique by inserting all dirs into a set.
    include_depset = depset(include_dir_list)

    args = ctx.actions.args()
    args.add_all("--include", include_depset.to_list())
    args.add("--out", out.path)
    args.add(top_file.path)

    ctx.actions.run(
        outputs = [ out ],
        inputs = all_input_files,
        tools = ctx.attr._device_tree_compiler.files,
        executable = dtc_path,
        arguments = [ args ],
        progress_message = "DeviceTree %{output}",
    )
    return [
        DefaultInfo(files = depset([out]))
    ]

device_tree_blob = rule(
    implementation = _device_tree_blob,
    attrs = {
        "top_level": attr.label(
           allow_files = [ ".dts" ],
        ),
        "srcs": attr.label_list(
            allow_files = [".dts", ".dtsi", ],
        ),
        "ext": attr.string(
            default = ".dtb",
        ),
        "_device_tree_compiler": attr.label(
            default = "@dtc//:dtc",
            executable = True,
            cfg = "exec",
        ),
    },
)
