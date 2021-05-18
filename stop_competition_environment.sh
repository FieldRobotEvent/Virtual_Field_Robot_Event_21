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
echo "Stopping for task $1"

cd $(dirname $0)/task_${1}

echo "Stopping containers for task $1."
docker-compose -p fre down
if [ $? -gt 0 ] ; then
  echo "Failed to stop containers?"
fi
