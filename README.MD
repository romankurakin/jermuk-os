# Jermuk OS

A bare-metal operating system for the Raspberry Pi, written in Zig. It is named after Jermuk (Ջերմուկ), a town in Armenia.

## About

Jermuk OS is a Zig implementation based on the [Rust Raspberry Pi OS Tutorials](https://github.com/rust-embedded/rust-raspberrypi-OS-tutorials). It follows the same educational approach but implements the concepts using the Zig programming language instead of Rust.

## Purpose

The goal of this project is to:

- Learn bare metal programming concepts using Zig
- Understand low-level hardware interactions on Raspberry Pi

## Supported Hardware

- Raspberry Pi 4B
- Raspberry Pi 5

## Prerequisites

- [Zig](https://ziglang.org/) compiler
- [Just](https://github.com/casey/just) command runner
- Docker (optional, for containerized builds)

## Development

This project uses Docker and [Just](https://github.com/casey/just) for development and building. The default configuration uses QEMU to run the kernel.

### Available Commands

```bash
# Build kernels for all supported boards
just build-all

# Run Raspberry Pi 4B in QEMU
just run

# List all available commands
just help
```

### Running in QEMU

The default `just run` command will:

1. Build the kernel for Raspberry Pi 4
2. Run it in QEMU

### Docker Configuration

The project uses a Docker for consistent development environment.

## Output Files

The build process generates kernel images for each supported board:

- `zig-out/bin/boards/raspi4b/kernel8.img` - For Raspberry Pi 4
- `zig-out/bin/boards/raspi5/kernel8.img` - For Raspberry Pi 5

## License

See [LICENSE](LICENSE) file for details.

## Acknowledgments

- The Rust Embedded Working Group for their excellent original tutorial
- The Zig community
