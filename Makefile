
IMAGE_NAME = blofroth/rust-s2i-musl-builder
TOOLCHAIN := stable

.PHONY: build
build:
	docker build --build-arg TOOLCHAIN=$(TOOLCHAIN) -t $(IMAGE_NAME):$(TOOLCHAIN) .

