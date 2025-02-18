"""Functions to set up the various rust-related dependencies."""

load("@rules_rust//rust:repositories.bzl", "rules_rust_dependencies", "rust_register_toolchains", "rust_repository_set")
load("@rules_rust//tools/rust_analyzer:deps.bzl", "rust_analyzer_dependencies")

RUST_NIGHTLY_DATE = "2024-02-01"

RUST_NIGHTLY_VERSION = "nightly/" + RUST_NIGHTLY_DATE

RUST_VERSIONS = [
    "1.76.0",
    RUST_NIGHTLY_VERSION,
]

RUST_SHA256S = {
    RUST_NIGHTLY_DATE + "/rustc-nightly-x86_64-unknown-linux-gnu.tar.xz": "7247ca497c7d9194c9e7bb9b6a51f8ccddc452bbce2977d608cabdbc1a0f332f",
    RUST_NIGHTLY_DATE + "/clippy-nightly-x86_64-unknown-linux-gnu.tar.xz": "1271eaa89d50bd7f63b338616c36f41fe1e733b5d6c4cc2c95eaa6b3c8faba62",
    RUST_NIGHTLY_DATE + "/cargo-nightly-x86_64-unknown-linux-gnu.tar.xz": "1d859549b5f3d2dd146b84aa13dfec24a05913653af2116b39a919cab69de850",
    RUST_NIGHTLY_DATE + "/llvm-tools-nightly-x86_64-unknown-linux-gnu.tar.xz": "b227753189981d9a115527ba0e95b365388fb0fe7f1a1ff93116c4448c854197",
    RUST_NIGHTLY_DATE + "/rust-std-nightly-x86_64-unknown-linux-gnu.tar.xz": "b1a444f8e8f33d813c4d532c12717743edd9b34f685ff5293b6375fc75c2421e",
    RUST_NIGHTLY_DATE + "/rustfmt-nightly-x86_64-unknown-linux-gnu.tar.xz": "7d80f21ff1e365241beae5dc070badea25a96466e974caa80d781bf5ce4965ee",
}

RUST_EDITION = "2021"

def setup_rust_dependencies(oak_repo_name = "oak"):
    """Set up the various rust-related dependencies. Call this after load_rust_repositories().


    Args:
        oak_repo_name: to be used when Oak repo is renamed.
    """
    rules_rust_dependencies()

    rust_register_toolchains(
        edition = RUST_EDITION,
        versions = RUST_VERSIONS,
        sha256s = RUST_SHA256S,
    )

    # Creates remote repositories for Rust toolchains, required for cross-compiling.
    rust_repository_set(
        name = "rust_toolchain_repo",
        edition = RUST_EDITION,
        exec_triple = "x86_64-unknown-linux-gnu",
        extra_rustc_flags = {
            "x86_64-unknown-none": [
                "-Crelocation-model=static",
                "-Ctarget-feature=+sse,+sse2,+ssse3,+sse4.1,+sse4.2,+avx,+avx2,+rdrand,-soft-float",
                "-Ctarget-cpu=x86-64-v3",
                "-Clink-arg=-zmax-page-size=0x200000",
            ],
        },
        extra_target_triples = {
            "x86_64-unknown-none": [
                "@platforms//cpu:x86_64",
                "@platforms//os:none",
                "@%s//bazel/rust:avx_ON" % oak_repo_name,
                "@%s//bazel/rust:code_model_NORMAL" % oak_repo_name,
            ],
        },
        versions = RUST_VERSIONS,
        sha256s = RUST_SHA256S,
    )

    rust_repository_set(
        name = "rust_noavx_toolchain_repo",
        edition = RUST_EDITION,
        exec_triple = "x86_64-unknown-linux-gnu",
        extra_rustc_flags = {
            # Disabling AVX implies soft-float is needed.
            "x86_64-unknown-none": ["-C", "target-feature=+soft-float"],
        },
        extra_target_triples = {
            "x86_64-unknown-none": [
                "@platforms//cpu:x86_64",
                "@platforms//os:none",
                "@%s//bazel/rust:avx_OFF" % oak_repo_name,
                "@%s//bazel/rust:code_model_NORMAL" % oak_repo_name,
            ],
        },
        versions = RUST_VERSIONS,
        sha256s = RUST_SHA256S,
    )

    # IDE support via rust-analyzer for bazel-only projects.
    # https://bazelbuild.github.io/rules_rust/rust_analyzer.html
    #
    # You can re-generate the rust-project.json file using:
    # bazel run @rules_rust//tools/rust_analyzer:gen_rust_project
    #
    # It should not be committed.
    #
    # VSCode users: There's a task included in .vscode/tasks.json that should
    # automatically do this for you when needed.
    rust_analyzer_dependencies()
