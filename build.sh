#!/bin/bash
SOURCE=${1}
BINARY_NAME=${2}

ALPINE_VERSION=${ALPINE_VERSION:-latest}

s2i build ${SOURCE} \
  blofroth/rust-s2i-musl-builder \
  -e "RUST_BINARY=${BINARY_NAME}" \
  --exclude "" \
  --incremental \
  "rust-musl-${BINARY_NAME}-tmp"

# secondary build as recommended by
# https://github.com/openshift/source-to-image/issues/738#issuecomment-299505477
s2i build ${SOURCE} \
  "rust-musl-${BINARY_NAME}-tmp" \
  --runtime-image "alpine:$ALPINE_VERSION" \
  --scripts-url "file://s2i/bin" \
  -e "RUST_BINARY=${BINARY_NAME}" \
  -e "RUNTIME_IMAGE_COPY=1" \
  -a "/home/rust/src/target/x86_64-unknown-linux-musl/release/${BINARY_NAME}:rust/" \
  "rust-musl-${BINARY_NAME}"
