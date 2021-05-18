#!/bin/bash
CONTAINERS=$(docker ps | tail -n +2 | sed 's/  */ /g')
if echo "$CONTAINERS" | grep fre_a_container_1; then
    if echo "$CONTAINERS" | grep fre_b_container_1; then
        echo 'Both containers running!'
        exit
    fi
fi

if [ -z "$1" ] ; then
TASK=1
echo "Defaulting to task $TASK"
else
TASK=$1
fi
echo "Starting for task $TASK"

cd $(dirname $0)/task_${TASK}

#echo 'Building containers.'
#docker-compose build

echo 'Starting containers.'
xauth nlist :0 | sed -e 's/^..../ffff/' | xauth -f /tmp/.docker.xauth nmerge -
#xhost +local:root #TODO find a safer way to do this (http://wiki.ros.org/docker/Tutorials/GUI) 
docker-compose -p fre up -d
if [ $? -gt 0 ] ; then
  echo "Failed to start containers!"
fi
