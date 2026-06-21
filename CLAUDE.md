# Project conventions for `rules_dtc`

## General change rules

* Ensure that tests pass after every change.
* When you need to generate scripts, always create file templates, then load
  those into rules (see `internal/*.sh.tpl`).
* If you need temporary files, put them in a `local/` subdir (create if needed).
* Keep generated documentation in sync: after touching any `.bzl` public API,
  run `bazel run //:update` and commit the regenerated `*.md`.

## Layout

* `//` — the public module `rules_dtc`. Public API is re-exported from
  `//:defs.bzl`; implementations live in `//internal`.
* `//integration` — a *separate* Bazel module (its own `MODULE.bazel`) that
  consumes `rules_dtc` via `local_path_override` and holds the worked examples /
  end-to-end tests. The root module ignores it via `.bazelignore`.

## Building and testing

* Root module: `bazel build //...` and `bazel test //...`.
* Integration module: `cd integration && bazel build //... && bazel test //...`.
* Lint: `bazel run //:buildifier`.

## Git commit rules

* Use Conventional Commits v1.0.0 for commit and PR messages.
* Prefer rebase over merge when integrating upstream changes.
* Use `gh` to create pull requests against `origin/main`.
