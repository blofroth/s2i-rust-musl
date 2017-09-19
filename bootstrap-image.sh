#!/bin/bash
USE_CARGO_HOME=${1}
BINARY_NAME=${2}

IMAGE_NAME=rust-musl-${BINARY_NAME}-tmp

cp -r ${USE_CARGO_HOME} ./
chmod -R 777 .cargo


docker build -t ${IMAGE_NAME} -f bootstrap.docker .