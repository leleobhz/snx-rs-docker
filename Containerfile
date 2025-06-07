## GIT

FROM --platform=$BUILDPLATFORM docker.io/library/alpine:latest AS git

ARG snx_rs_version 2.8.1
ENV CARGO_HOME=/cargo
ENV RUSTUP_TOOLCHAIN=stable

RUN apk --no-cache add git curl libgcc tree
RUN git clone --single-branch --depth=1 --branch=v${snx_rs_version} https://github.com/ancwrd1/snx-rs.git /snx-rs

RUN curl -sSLf https://sh.rustup.rs | sh -s -- -y
WORKDIR /snx-rs
RUN . "/cargo/env" \
 && mkdir -p .cargo \
 && cargo vendor > .cargo/config.toml

## SNX-RS
FROM docker.io/library/debian:stable-slim AS builder

ENV CARGO_HOME=/cargo
ENV RUSTUP_TOOLCHAIN=stable

COPY --from=git /snx-rs /usr/src/snx-rs

RUN apt -qq update \
 && apt -qqy --no-install-recommends install catatonit ca-certificates \
 && apt -qqy install curl pkgconf clang libssl-dev

RUN /usr/bin/curl -sSLf https://sh.rustup.rs | sh -s -- -y

WORKDIR /usr/src/snx-rs

RUN . "/cargo/env" \
 && cd /usr/src/snx-rs \
 && cargo build --offline --frozen --release --workspace --exclude snx-rs-gui --exclude snxctl

# Final
FROM docker.io/library/debian:stable-slim

RUN apt -qq update \
 && apt -qq -y install procps ca-certificates iproute2 iptables \
 && rm -rf /var/lib/apt/lists/*

COPY --from=builder /usr/bin/catatonit /usr/bin/catatonit
COPY --from=builder /usr/src/snx-rs/target/release/snx-rs /usr/bin/

VOLUME /var/cache/snx-rs/sessions

ENTRYPOINT ["/usr/bin/catatonit", "-g", "--"]
CMD ["/usr/bin/snx-rs"]
