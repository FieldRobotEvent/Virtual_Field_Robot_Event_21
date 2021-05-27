#!/bin/bash

#We installed nvidia-docker to get access to the nvidia runtime. This allows the gpu cards to be mounted inside the containers.

#/etc/docker/daemon.json still uses the default runtime as 'nvidia'. We probably need to test that one out...

MYPATH=$(readlink -f $(dirname $0))

NETNAME=fre_default
if ! docker network ls --format "{{.Name}}" | grep "$NETNAME" ; then
  docker network create "$NETNAME"
fi

A_NAME=fre_a_container_1
if ! docker ps --format "{{.Names}}" | grep "$A_NAME" ; then
docker run -d \
  --name "$A_NAME" \
  -h acontainer \
  -v "${MYPATH}/task_1/worlds:/catkin/src/Virtual_Field_Robot_Event/virtual_maize_field/worlds" \
  -v "${MYPATH}/task_1/Media:/catkin/src/Virtual_Field_Robot_Event/virtual_maize_field/Media" \
  -v "${MYPATH}/task_1/map:/catkin/src/Virtual_Field_Robot_Event/virtual_maize_field/map" \
  -v "${MYPATH}/task_1/launch:/catkin/src/Virtual_Field_Robot_Event/virtual_maize_field/launch" \
  -v "/tmp/.X11-unix:/tmp/.X11-unix:rw" \
  -v "/tmp/.docker.xauth:/tmp/.docker.xauth:rw" \
  -e "DISPLAY=:1" \
  -e "NVIDIA_DRIVER_CAPABILITIES=all" \
  --runtime nvidia \
  --gpus all \
  --network "$NETNAME" \
  fieldrobotevent/a_container_2021
fi

B_IMAGENAME=b_task_1
if ! docker images --format "{{.Repository}}" | grep "$B_IMAGENAME" ; then
  cd b_container && docker build -t "$B_IMAGENAME" . && cd
fi

B_NAME=fre_b_container_1
if ! docker ps --format "{{.Names}}" | grep "$B_NAME" ; then
docker run -d \
  --name "$B_NAME" \
  -h bcontainer \
  --network "$NETNAME" \
  "$B_IMAGENAME"
fi
