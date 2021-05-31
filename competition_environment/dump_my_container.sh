#!/bin/bash
if [ -z $1 ] ; then
  TASK=1
  echo "Defaulting to task $TASK"
else
  TASK=$1
fi
echo "Dumping for task $TASK"

IMAGES=$(docker ps -a | tail -n +2 | sed 's/  */ /g')
if echo $IMAGES | grep -v b_task_$TASK ; then
    echo "You don't have a b_task_$TASK image present. Try starting the competition environment for task $TASK first."
    exit 1
fi


echo "This script will dump the committed b_task_$TASK image to a file. Be aware that you have to commit changes for this to work!"
sleep 2

echo "Dumping b_task_$TASK to b_task_${TASK}.tgz now."
echo "This may take several minutes."
docker image save b_task_$TASK | gzip -c - > b_task_${TASK}.tgz
echo "Please upload this file for competition purposes if your code is not public."
