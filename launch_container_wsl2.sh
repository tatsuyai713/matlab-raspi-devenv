#!/bin/sh
SCRIPT_DIR=$(cd $(dirname $0); pwd)

NAME_IMAGE="raspi_docker_image_${USER}"

if [ ! $# -ne 1 ]; then
	if [ "commit" = $1 ]; then
		docker commit raspi_docker ${NAME_IMAGE}:latest
		CONTAINER_ID=$(docker ps -a -f name=raspi_docker --format "{{.ID}}")
		docker rm $CONTAINER_ID
		exit 0
	else
		echo "Docker image is found. Setup is already finished!"
	fi
fi

if [ ! $# -ne 1 ]; then
	if [ "stop" = $1 ]; then
		CONTAINER_ID=$(docker ps -a -f name=raspi_docker --format "{{.ID}}")
		docker stop $CONTAINER_ID
		docker rm $CONTAINER_ID
		exit 0
	else
		echo "Docker image is found. Setup is already finished!"
	fi
fi

XAUTH=/tmp/.docker.xauth
touch $XAUTH
xauth_list=$(xauth nlist :0 | sed -e 's/^..../ffff/')
if [ ! -z "$xauth_list" ];  then
  echo $xauth_list | xauth -f $XAUTH nmerge -
fi
chmod a+r $XAUTH

DOCKER_OPT=""
DOCKER_NAME="raspi_docker"
DOCKER_WORK_DIR="/home/pi"
DISPLAY=$(hostname):0

## For XWindow
DOCKER_OPT="${DOCKER_OPT} \
        --env=QT_X11_NO_MITSHM=1 \
        --volume=/tmp/.X11-unix:/tmp/.X11-unix:rw \
        --env=XAUTHORITY=${XAUTH} \
        --volume=${XAUTH}:${XAUTH} \
        --env=DISPLAY=${DISPLAY} \
		--shm-size=1gb \
		--env=TERM=xterm-256color \
        -w ${DOCKER_WORK_DIR} \
		-p 22:20022 \
        -u pi \
        --hostname Raspi-`hostname`"
		
		
## Allow X11 Connection
xhost +local:Raspi-`hostname`

CONTAINER_ID=$(docker ps -a -f name=raspi_docker --format "{{.ID}}")
if [ ! "$CONTAINER_ID" ]; then
	docker run ${DOCKER_OPT} \
		-itd \
		--name=${DOCKER_NAME} \
		${NAME_IMAGE}:latest
fi

CONTAINER_ID=$(docker ps -a -f name=raspi_docker --format "{{.ID}}")
if [ ! "$CONTAINER_ID" ]; then
	docker run ${DOCKER_OPT} \
		-it \
		--name=${DOCKER_NAME} \
		${NAME_IMAGE}:latest \
		bash
else
	docker start $CONTAINER_ID
	docker attach $CONTAINER_ID
fi

xhost -local:Raspi-`hostname`

