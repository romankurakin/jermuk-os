# Default configuration
DOCKER_IMAGE := "zig-qemu-raspi"
DOCKER_CMD := "docker run --rm -v `pwd`:/app -w /app"

# Default recipe is `run`
default:
    @just run

# Docker management
docker-build:
    docker build -t {{DOCKER_IMAGE}} .

# Build for all boards
build: docker-build
    {{DOCKER_CMD}} {{DOCKER_IMAGE}} zig build

# Run Raspberry Pi 4 in QEMU
run: build
    {{DOCKER_CMD}} {{DOCKER_IMAGE}} \
        qemu-system-aarch64 \
        -M raspi4b \
        -kernel zig-out/bin/boards/raspi4b/kernel8.img \
        -serial stdio \
        -display none \
        -d in_asm

# Clean build directory
clean:
    rm -rf zig-out

# Format code
fmt: docker-build
    {{DOCKER_CMD}} {{DOCKER_IMAGE}} zig fmt .

# List all recipes
help:
    @just --list