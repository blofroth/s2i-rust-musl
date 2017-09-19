
# Building Rust Musl Docker images

This repo contains S2I configuration and wrapping scripts to build small
Musl+Alpine based Docker images from Rust projects.

## Prerequisites

 * [Source-to-image (S2I)](https://github.com/openshift/source-to-image) (tested with v1.1.7-dirty on OSX)
 * [Docker](https://www.docker.com/community-edition#/download) (tested with 17.06.2-ce)
 * [Rust Musl Builder](https://github.com/emk/rust-musl-builder)
    
    * a. Either use the images in Docker Hub (`ekidd/rust-musl-builder:(stable|beta|nightly|1.XX.X`)
    * b. Or checkout and build one yourself:
        docker build --build-arg TOOLCHAIN=nightly-2017-09-27 -t ekidd/rust-musl-builder:nightly-2017-09-27

## Building an image from scratch
This is the simple most basic use case.

1. Create the builder image (`blofroth/rust-s2i-musl-builder`)

    a. From `stable` (default):
    
       make

    b. From a specific toolchain (assumes the `rust-musl-builder` version exists):

       make TOOLCHAIN=nightly-2017-09-27

2. Build the Musl binary and set it up on a `alpine` image:

       sh build.sh SOURCE BINARY_NAME

* `SOURCE` - a S2I source (e.g. Git url or local path to git repo)

* `BINARY_NAME` - assumed to be the name of the created binary, also passed with 
    `--bin` to `cargo`

This should create two images:
    * `rust-musl-${BINARY_NAME}-tmp`
        * temporary image based on the builder image, used for incremental builds
    * `rust-musl-${BINARY_NAME}`
        * actual Alpine based container with binary

## Building an image incrementally from the last one
Simply:

    sh build.sh SOURCE BINARY_NAME

## Building with a bootstrapped cargo registry

1. Prepare a cargo cache from the locally checked out Rust project repository

        CARGO_HOME=/tmp/.cargo cargo fetch

2. Use the bootstrap script:

        sh bootstrap-image.sh /tmp/.cargo BINARY_NAME

    * `BINARY_NAME` - needed for the name of the bootstrapped "faked" last builder image

3. Build as with the other methods:

    * `sh build.sh SOURCE BINARY_NAME`

## Where to go from here

My plan is to soon provide an example project with some microservices based on Rocket.rs
and deployable in OpenShift. Stay tuned... :)

## Gotchas for Rust + S2I
From the help documentation of `s2i`:

    --exclude string  Regular expression for selecting files from the source tree to exclude from the build, where the default excludes the '.git' directory (see https://golang.org/pkg/regexp for syntax, but note that "" will be interpreted as allow all files and exclude no files) (default "(^|/)\.git(/|$)")

Note that this exclusion string is also applied for `tar` with the `save-artifacts` script, inconveniently messing up the cargo `crates-io` git checkout. The simple solution if you don't
mind also passing `.git` directories in the source also to the `assemble` script is to exclude nothing:

    --exclude ""

## Acknowledgements
Based on and influenced by:
* [S2I](https://github.com/openshift/source-to-image)
* [Rust Musl Builder](https://github.com/emk/rust-musl-builder)
* [Rust S2I](https://github.com/lawliet89/rust-s2i)