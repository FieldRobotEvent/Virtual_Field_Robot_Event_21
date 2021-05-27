#!/bin/bash

#We installed nvidia-docker to get access to the nvidia runtime. This allows the gpu cards to be mounted inside the containers.

#/etc/docker/daemon.json still uses the default runtime as 'nvidia'. We probably need to test that one out...

docker network create fre_default
docker run -d \
  --name fre_a_container_1 \
  -h acontainer \
  -v "/home/fre/catkin_ws/src/Virtual_Field_Robot_Event/competition_environment/task_1/worlds:/catkin/src/Virtual_Field_Robot_Event/virtual_maize_field/worlds" \
  -v "/home/fre/catkin_ws/src/Virtual_Field_Robot_Event/competition_environment/task_1/Media:/catkin/src/Virtual_Field_Robot_Event/virtual_maize_field/Media" \
  -v "/home/fre/catkin_ws/src/Virtual_Field_Robot_Event/competition_environment/task_1/map:/catkin/src/Virtual_Field_Robot_Event/virtual_maize_field/map" \
  -v "/home/fre/catkin_ws/src/Virtual_Field_Robot_Event/competition_environment/task_1/launch:/catkin/src/Virtual_Field_Robot_Event/virtual_maize_field/launch" \
  -v "/tmp/.X11-unix:/tmp/.X11-unix:rw" \
  -v "/tmp/.docker.xauth:/tmp/.docker.xauth:rw" \
  -e "DISPLAY=:1" \
  -e "NVIDIA_DRIVER_CAPABILITIES=all" \
  --runtime nvidia \
  --gpus all \
  --network fre_default \
  fieldrobotevent/a_container_2021

#Check if b_task_1 exists then:
#cd b_container && docker build -t b_task_1 . && cd

docker run -d \
  --name fre_b_container_1 \
  -h bcontainer \
  --network fre_default \
  b_task_1

