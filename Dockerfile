
ARG TOOLCHAIN=stable
FROM ekidd/rust-musl-builder:${TOOLCHAIN}

MAINTAINER Björn Löfroth <bjorn.lofroth@gmail.com>

LABEL io.k8s.description="Platform for building Rust Applications" \
     io.k8s.display-name="Rust Musl S2I Builder" \
     io.openshift.expose-services="8000:http" \
     io.openshift.tags="rust" \
     io.openshift.s2i.scripts-url="image:///usr/libexec/s2i" 

COPY ./s2i/bin/ /usr/libexec/s2i

USER rust

CMD ["/usr/libexec/s2i/usage"]
