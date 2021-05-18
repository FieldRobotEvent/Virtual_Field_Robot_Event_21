#!/bin/bash
CONTAINERS=$(docker ps -a | tail -n +2 | sed 's/  */ /g')
if echo $CONTAINERS | grep -v compose_b_container_1 ; then
    echo "You don't have a default b_container present. Try starting the competition environment."
    exit 1
fi

echo "Spawning a shell in b container. Feel free to edit this container, but don't remove it without committing otherwise all changes will be deleted."
docker exec -it compose_b_container_1 /bin/bash
