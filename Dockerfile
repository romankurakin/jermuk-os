FROM fedora:41

RUN dnf -y upgrade && \
    dnf -y install \
    zig-0.13.0 \
    qemu-system-aarch64 \
    && dnf clean all

WORKDIR /app
