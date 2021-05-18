#!/bin/bash
IMAGES=$(docker ps -a | tail -n +2 | sed 's/  */ /g')
if echo $IMAGES | grep -v b_container ; then
    echo "You don't have a b_container image present. Try starting the competition environment."
    exit 1
fi

echo "This script will dump the committed b_container image to a file. Be aware that you have to commit changes for this to work!"
sleep 2

echo "Dumping b_container to b_container.tgz now."
docker image save b_container | gzip -c - > b_container.tgz
echo "Please upload this file for competition purposes if your code is not public."
