#!/bin/bash
CONTAINERS=$(docker ps -a | tail -n +2 | sed 's/  */ /g')
if echo $CONTAINERS | grep -v fre_b_container_1 ; then
    echo "You don't have a default b_container present. Try starting the competition environment."
    exit 1
fi

echo "Spawning a shell in b container. Feel free to edit this container, but don't remove it without committing otherwise all changes will be deleted."
if ! docker exec -it fre_b_container_1 /bin/bash ; then
  echo "Looks like your B container died... Starting it temporarily."
  docker start -a fre_b_container_1 &
  sleep 4
  docker exec -it fre_b_container_1 /bin/bash
fi

