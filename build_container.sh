#!/bin/bash
SCRIPT_DIR=$(cd $(dirname "$0") && pwd)
cd $SCRIPT_DIR
pwd

BASE_IMAGE="ghcr.io/tatsuyai713/matlab-raspi-devenv"
NAME_IMAGE="raspi_docker_image_${USER}"

if [ "$(docker image ls -q ${NAME_IMAGE})" ]; then
	echo "Docker image is already built!"
	exit
fi

echo "Build Container"

docker build --platform linux/arm/v7 --file=./noproxy.dockerfile -t ${NAME_IMAGE} .

echo "_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/"
echo "_/Building container image is finished!!_/"
echo "_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/"
