#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o xtrace
set -o pipefail

export CI=kokoro

export RUST_BACKTRACE=1
export RUST_LOG=debug
export XDG_RUNTIME_DIR=/var/run

./scripts/docker_pull
./scripts/docker_run nix develop .#containers --command just kokoro_oak_containers

mkdir -p "$KOKORO_ARTIFACTS_DIR/test_logs/"
cp ./target/nextest/default/*.xml "$KOKORO_ARTIFACTS_DIR/test_logs/" || true

mkdir -p "$KOKORO_ARTIFACTS_DIR/binaries/"

# Store the git commit hash in the name of an empty file, so that it can be efficiently found via a glob.
touch "$KOKORO_ARTIFACTS_DIR/binaries/git_commit_${KOKORO_GIT_COMMIT_oak:?}"

# Copy the generated binaries to Placer.
export GENERATED_BINARIES=(
    ./target/stage1.cpio
    ./oak_containers_kernel/target/vmlinux
    ./oak_containers_system_image/target/image.tar.xz
)
cp "${GENERATED_BINARIES[@]}" "$KOKORO_ARTIFACTS_DIR/binaries/"

ls -alsR "$KOKORO_ARTIFACTS_DIR/binaries"
