#!/bin/bash
if [ -z $1 ] ; then
  $1=1
  echo "Defaulting to task $1"
fi
echo "Dumping for task $1"

IMAGES=$(docker ps -a | tail -n +2 | sed 's/  */ /g')
if echo $IMAGES | grep -v b_task_$1 ; then
    echo "You don't have a b_task_$1 image present. Try starting the competition environment for task $1 first."
    exit 1
fi


echo "This script will dump the committed b_task_$1 image to a file. Be aware that you have to commit changes for this to work!"
sleep 2

echo "Dumping b_task_$1 to b_task_${1}.tgz now."
docker image save b_task_$1 | gzip -c - > b_task_${1}.tgz
echo "Please upload this file for competition purposes if your code is not public."
