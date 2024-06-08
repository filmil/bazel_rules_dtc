load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")
load("@bazel_tools//tools/build_defs/repo:git.bzl", "new_git_repository")
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

git_repository(
    name = "rules_foreign_cc",
    commit = "6ecc134b114f6e086537f5f0148d166467042226",
    remote = "https://github.com/bazelbuild/rules_foreign_cc",
    shallow_since = "1686730970 +0000",
)

load("@rules_foreign_cc//foreign_cc:repositories.bzl", "rules_foreign_cc_dependencies")

rules_foreign_cc_dependencies()

rules_hdl_git_hash = "ebaf7482c035208f485f463c62fd3c2f969a9b5c"

rules_hdl_git_sha256 = "3743f1ed6739abaaa68e1e907adffb13c285fd70390d950c3989729439d952c5"

maybe(
    git_repository,
    name = "rules_hdl",
    commit = "6689294f2d4f45de02a527d947b4703b4c008b53",
    remote = "https://github.com/hdl/bazel_rules_hdl",
    shallow_since = "1676530055 -0800",
)

load("@rules_hdl//toolchains/cpython:cpython_toolchain.bzl", "register_cpython_repository")

register_cpython_repository()

register_toolchains("@rules_hdl//toolchains/cpython:cpython_toolchain")

maybe(
    http_archive,
    name = "rules_python",
    sha256 = "b6d46438523a3ec0f3cead544190ee13223a52f6a6765a29eae7b7cc24cc83a0",
    url = "https://github.com/bazelbuild/rules_python/releases/download/0.1.0/rules_python-0.1.0.tar.gz",
)

maybe(
    http_archive,
    name = "rules_pkg",
    sha256 = "a89e203d3cf264e564fcb96b6e06dd70bc0557356eb48400ce4b5d97c2c3720d",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/rules_pkg/releases/download/0.5.1/rules_pkg-0.5.1.tar.gz",
        "https://github.com/bazelbuild/rules_pkg/releases/download/0.5.1/rules_pkg-0.5.1.tar.gz",
    ],
)

http_archive(
    name = "com_grail_bazel_toolchain",
    sha256 = "ddad1bde0eb9d470ea58500681a7deacdf55c714adf4b89271392c4687acb425",
    strip_prefix = "toolchains_llvm-7e7c7cf1f965f348861085183d79b6a241764390",
    urls = ["https://github.com/grailbio/bazel-toolchain/archive/7e7c7cf1f965f348861085183d79b6a241764390.tar.gz"],
)

load("@com_grail_bazel_toolchain//toolchain:deps.bzl", "bazel_toolchain_dependencies")

bazel_toolchain_dependencies()

load("@com_grail_bazel_toolchain//toolchain:rules.bzl", "llvm_toolchain")

llvm_toolchain(
    name = "llvm_toolchain",
    llvm_version = "10.0.1",
    sha256 = {
        "linux": "02a73cfa031dfe073ba8d6c608baf795aa2ddc78eed1b3e08f3739b803545046",
    },
    strip_prefix = {
        "linux": "clang+llvm-10.0.1-x86_64-pc-linux-gnu",
    },
    urls = {
        "linux": [
            # Use a custom built Clang+LLVM binary distribution that is more portable than
            # the official builds because it's built against an older glibc and does not have
            # dynamic library dependencies to tinfo, gcc_s or stdlibc++.
            #
            # For more details, see the files under toolchains/clang.
            "https://github.com/retone/deps/releases/download/na5/clang+llvm-10.0.1-x86_64-pc-linux-gnu.tar.xz",
        ],
    },
    # Disabled for now waiting on https://github.com/pybind/pybind11_bazel/pull/29
    # sysroot = {
    #     "linux": "@org_chromium_sysroot_linux_x64//:sysroot",
    # },
)


# Device Tree Compiler proper.
new_git_repository(
    name = "dtc",
    build_file = "//third_party/dtc:dtc.BUILD.bazel",
    commit = "ccf1f62d59adc933fb348b866f351824cdd00c73",
    remote = "https://github.com/dgibson/dtc",
    shallow_since = "1686217671 +1000",
)
