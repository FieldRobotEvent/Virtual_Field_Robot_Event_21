#!/bin/bash
CONTAINERS=$(docker ps -a | tail -n +2 | sed 's/  */ /g')
if echo $CONTAINERS | grep -v compose_b_container_1 ; then
    echo "You don't have a default b_container present. Try starting the competition environment."
    exit 1
fi

echo 'Now saving the edited b container...'
docker commit compose_b_container_1 b_container

