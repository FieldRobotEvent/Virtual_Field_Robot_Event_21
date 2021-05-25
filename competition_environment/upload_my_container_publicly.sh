#!/bin/bash
if [ -z $1 ] ; then
  $TASK=1
  echo "Defaulting to task $TASK"
else
  $TASK=$1
fi
echo "Uploading image for task $TASK"

IMAGES=$(docker ps -a | tail -n +2 | sed 's/  */ /g')
if echo $IMAGES | grep -v b_task_$TASK ; then
    echo "You don't have a b_task_$TASK image present. Try starting the competition environment for task $TASK first."
    exit 1
fi

echo "Please enter your hub.docker.com username here so I can tag your image nicely."
echo "If you don't have one, break this and go to https://hub.docker.com to get one sorted."
echo ''
read -p "Username: " DOCKER_USER

docker tag b_task_$TASK ${DOCKER_USER}/b_task_$TASK

echo "Tagged. Now prompting for login to hub.docker.com ..."
docker login --username $DOCKER_USER

echo "Pushing now to hub.docker.com ..."

docker push ${DOCKER_USER}/b_task_$TASK

echo "Done. Please let the organisers know to use the container called ${DOCKER_USER}/b_task_$TASK"

