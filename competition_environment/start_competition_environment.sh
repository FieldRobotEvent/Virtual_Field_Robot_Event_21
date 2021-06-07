#!/bin/bash
if [ -z "$1" ] ; then
TASK=1
echo "Defaulting to task $TASK"
else
TASK=$1
fi
echo "Starting for task $TASK"

#We installed nvidia-docker2 to get access to the nvidia runtime. This allows the gpu cards to be mounted inside the containers.

## parse inputs
NETNAME=fre_default
A_IMAGENAME=fieldrobotevent/a_container_2021
#You will probably want to be changing this for competition times...

if [ -z "$2" ] ; then
B_IMAGENAME=b_task_$TASK
else
B_IMAGENAME=b_task_${TASK}_${2}
fi
echo "Starting with image $B_IMAGENAME"

A_NAME=fre_a_container_1
B_NAME=fre_b_container_1

## configure x forwarding
MYPATH=$(readlink -f $(dirname $0))
xauth nlist :0 | sed -e 's/^..../ffff/' | xauth -f /tmp/.docker.xauth nmerge -

# configure network
if ! docker network ls --format "{{.Name}}" | grep "$NETNAME" ; then
  docker network create "$NETNAME"
fi

# enable GPU
RUNTIME=''
if docker info | grep Runtimes | grep nvidia ; then
  RUNTIME='--runtime nvidia --gpus all'
fi

# launch the a container
if ! docker ps --format "{{.Names}}" | grep "$A_NAME" ; then
docker run -d \
  --name "$A_NAME" \
  -h acontainer \
  -v "${MYPATH}/task_${TASK}/worlds:/catkin/src/Virtual_Field_Robot_Event/virtual_maize_field/worlds" \
  -v "${MYPATH}/task_${TASK}/Media:/catkin/src/Virtual_Field_Robot_Event/virtual_maize_field/Media" \
  -v "${MYPATH}/task_${TASK}/map:/catkin/src/Virtual_Field_Robot_Event/virtual_maize_field/map" \
  -v "${MYPATH}/task_${TASK}/launch:/catkin/src/Virtual_Field_Robot_Event/virtual_maize_field/launch" \
  -v "/tmp/.X11-unix:/tmp/.X11-unix:rw" \
  -v "/tmp/.docker.xauth:/tmp/.docker.xauth:rw" \
  -e "DISPLAY=$DISPLAY" \
  -e "NVIDIA_DRIVER_CAPABILITIES=all" \
  $RUNTIME \
  --network "$NETNAME" \
  "$A_IMAGENAME"
fi

## build b container if needed
if ! docker images --format "{{.Repository}}" | grep "$B_IMAGENAME" ; then
  read -p "Do you want to build $B_IMAGENAME (reply with y or Y): " -n 1 -r
  if [[ $REPLY =~ ^[Yy]$ ]]
    then
      # build the b_container
      cd b_container && docker build -t "$B_IMAGENAME" . && cd
  else
    exit 1
  fi
fi

# set computation limits
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
