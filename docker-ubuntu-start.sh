#!/bin/bash
$(boot2docker shellinit)

CONTAINER_NAME="docker-ubuntu"

docker ps -a |grep ${CONTAINER_NAME} > /dev/null && test $? && echo container ${CONTAINER_NAME} already running, connecting.. || docker run -it -h "${CONTAINER_NAME}" --name="${CONTAINER_NAME}" -v /opt/docker-volume-ubuntu:/tmp -w /opt -d  ubuntu:14.10 /bin/sh -c "while true; do echo Hello world; sleep 1; done"
docker exec -it ${CONTAINER_NAME} bash 
