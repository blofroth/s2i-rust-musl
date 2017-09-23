
IMAGE_NAME = blofroth/s2i-rust-musl
TOOLCHAIN := stable

.PHONY: build
build:
	docker build --build-arg TOOLCHAIN=$(TOOLCHAIN) -t $(IMAGE_NAME):$(TOOLCHAIN) .

