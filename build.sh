#!/bin/bash
SOURCE=${1}
BINARY_NAME=${2}
TOOLCHAIN=${3:-stable}
ALPINE_VERSION=${4:-latest}

s2i build ${SOURCE} \
  "blofroth/s2i-rust-musl:${TOOLCHAIN}" \
  -e "RUST_BINARY=${BINARY_NAME}" \
  --exclude "" \
  --incremental \
  "rust-musl-${BINARY_NAME}-tmp"

# secondary build as recommended by
# https://github.com/openshift/source-to-image/issues/738#issuecomment-299505477
# to get incremental build while using a runtime image
s2i build ${SOURCE} \
  "rust-musl-${BINARY_NAME}-tmp" \
  --runtime-image "alpine:$ALPINE_VERSION" \
  --scripts-url "file://s2i/bin" \
  -e "RUST_BINARY=${BINARY_NAME}" \
  -e "RUNTIME_IMAGE_COPY=1" \
  -a "/home/rust/src/target/x86_64-unknown-linux-musl/release/${BINARY_NAME}:rust/" \
  "rust-musl-${BINARY_NAME}"
