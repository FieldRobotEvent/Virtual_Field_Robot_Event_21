#!/bin/bash
CONTAINERS=$(docker ps | tail -n +2 | sed 's/  */ /g')
if echo "$CONTAINERS" | grep compose_a_container_1; then
    if echo "$CONTAINERS" | grep compose_b_container_1; then
        echo 'Both containers running!'
        exit
    fi
fi

if [ -z $1 ] ; then
  $1=1
  echo "Defaulting to task $1"
fi
echo "Starting for task $1"

cd $(dirname $0)/task_${1}

#echo 'Building containers.'
#docker-compose build

echo 'Starting containers.'
xhost +local:root #TODO find a safer way to do this (http://wiki.ros.org/docker/Tutorials/GUI) 
docker-compose -p fre up -d
if [ $? -gt 0 ] ; then
  echo "Failed to start containers!"
fi
