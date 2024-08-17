#!/bin/bash

NAME_IMAGE="raspi_docker_base_image"
echo "Build Base Container"

# docker build -f common.dockerfile -t ghcr.io/tatsuyai713/${NAME_IMAGE}:v0.01 .
docker import --platform linux/arm/v7 ./raspi_image.tar ghcr.io/tatsuyai713/matlab-raspi-devenv:R2021a
docker push ghcr.io/tatsuyai713/matlab-raspi-devenv:R2021a