load("@bazel_tools//tools/build_defs/repo:git.bzl", "new_git_repository")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")


def rules_dtc_dependencies():
    maybe (
        new_git_repository,
        name = "dtc",
        build_file = Label("//third_party/dtc:dtc.BUILD.bazel"),
        commit = "ccf1f62d59adc933fb348b866f351824cdd00c73",
        remote = "https://github.com/dgibson/dtc",
        shallow_since = "1686217671 +1000",
    )
