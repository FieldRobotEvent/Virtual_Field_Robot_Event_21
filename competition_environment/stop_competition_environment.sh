#!/bin/bash
if [ -z "$1" ] ; then
TASK=1
echo "Defaulting to task $TASK"
else
TASK=$1
fi
echo "Stopping for task $TASK"

cd $(dirname $0)/task_${TASK}

echo "Stopping containers for task $TASK."
docker-compose -p fre down
if [ $? -gt 0 ] ; then
  echo "Failed to stop containers?"
fi
