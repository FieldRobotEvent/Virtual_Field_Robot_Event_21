#!/bin/bash
if [ -z "$1" ] ; then
TASK=1
echo "Defaulting to task $TASK"
else
TASK=$1
fi
echo "Stopping for task $TASK"

#We installed nvidia-docker to get access to the nvidia runtime. This allows the gpu cards to be mounted inside the containers.

#/etc/docker/daemon.json still uses the default runtime as 'nvidia'. We probably need to test that one out...

NETNAME=fre_default
A_IMAGENAME=fieldrobotevent/a_container_2021
#You will probably want to be changing this for competition times...
B_IMAGENAME=b_task_$TASK
A_NAME=fre_a_container_1
B_NAME=fre_b_container_1

MYPATH=$(readlink -f $(dirname $0))
xauth nlist :0 | sed -e 's/^..../ffff/' | xauth -f /tmp/.docker.xauth nmerge -

if ! docker network ls --format "{{.Name}}" | grep "$NETNAME" ; then
  docker network create "$NETNAME"
fi

RUNTIME=''
if docker info | grep Runtimes | grep nvidia ; then
  RUNTIME='--runtime nvidia --gpus all'
fi

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
  -e "DISPLAY=$DISPLAY" \
  -e "NVIDIA_DRIVER_CAPABILITIES=all" \
  $RUNTIME \
  --network "$NETNAME" \
  "$A_IMAGENAME"
fi

if ! docker images --format "{{.Repository}}" | grep "$B_IMAGENAME" ; then
  cd b_container && docker build -t "$B_IMAGENAME" . && cd
fi

if ! docker ps --format "{{.Names}}" | grep "$B_NAME" ; then
docker run -d \
  --name "$B_NAME" \
  -h bcontainer \
  --network "$NETNAME" \
  --cpu-quota 100000 \
  --cpu-period 10000 \
  --memory 48g \
  "$B_IMAGENAME"
fi
