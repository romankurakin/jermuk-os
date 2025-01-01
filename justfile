DOCKER_IMAGE := "zig-qemu-raspi"

DOCKER_CMD := "docker run --rm -v `pwd`:/app -w /app"

RASPI_MODEL := "raspi4b"

# Default recipe is `run`.
default:
  @just run

#------------------------------------------------------------------------------
# docker-build: Build the Docker image from Dockerfile in this directory
#------------------------------------------------------------------------------
docker-build:
  docker build -t {{DOCKER_IMAGE}} .

#------------------------------------------------------------------------------
# build: (1) ensures docker image is built, (2) runs `zig build` in container
#------------------------------------------------------------------------------
build: docker-build
  {{DOCKER_CMD}} {{DOCKER_IMAGE}} zig build

#------------------------------------------------------------------------------
# run: (1) build, (2) run QEMU inside container
#------------------------------------------------------------------------------
run: build
  {{DOCKER_CMD}} {{DOCKER_IMAGE}} \
    qemu-system-aarch64 \
      -M {{RASPI_MODEL}} \
      -kernel zig-out/bin/kernel8.img \
      -serial stdio \
      -display none \
      -d in_asm

#------------------------------------------------------------------------------
# clean
#------------------------------------------------------------------------------
clean:
  rm -rf zig-out

#------------------------------------------------------------------------------
# flash: copy kernel to an SD card (stub)
#------------------------------------------------------------------------------
flash path="/media/sdboot":
  @echo "Copying kernel8.img to {{path}}..."
  cp zig-out/bin/kernel8.img {{path}}
  @echo "Flashed kernel8.img!"