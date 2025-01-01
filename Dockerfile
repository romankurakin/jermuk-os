FROM fedora:latest

RUN dnf -y upgrade && \
    dnf -y install \
    zig \
    qemu-system-aarch64 \
    && dnf clean all

WORKDIR /app
