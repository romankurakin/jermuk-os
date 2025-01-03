# Default configuration
DOCKER_IMAGE := "zig-qemu-raspi"
DOCKER_CMD := "docker run --rm -v `pwd`:/app -w /app"
DEFAULT_BOARD := "raspi4b"

# Default recipe is `run`
default:
    @just run

# Docker management
docker-build:
    docker build -t {{DOCKER_IMAGE}} .

# Build for specific board
build board=DEFAULT_BOARD: docker-build
    {{DOCKER_CMD}} {{DOCKER_IMAGE}} zig build -Dboard={{board}}

# Run specific board in QEMU
run board=DEFAULT_BOARD: (build board)
    {{DOCKER_CMD}} {{DOCKER_IMAGE}} \
        qemu-system-aarch64 \
        -M {{board}} \
        -kernel zig-out/bin/boards/{{board}}/kernel8.img \
        -serial stdio \
        -display none \
        -d in_asm

# Build for all supported boards
build-all: docker-build
    just build raspi4b
    just build raspi5

# Clean build directory
clean:
    rm -rf zig-out

# Format code
fmt: docker-build
    {{DOCKER_CMD}} {{DOCKER_IMAGE}} zig fmt .

# List all recipes
help:
    @just --list
