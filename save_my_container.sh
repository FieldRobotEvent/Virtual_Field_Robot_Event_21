#!/bin/bash
CONTAINERS=$(docker ps -a | tail -n +2 | sed 's/  */ /g')
if echo $CONTAINERS | grep -v fre_b_container_1 ; then
    echo "You don't have a default b_container present. Try starting the competition environment."
    exit 1
fi

echo 'Now saving the edited b container...'
TO_IMG=$(docker ps -a --format '{{ .Names }} {{.Image}}' | grep fre_b_container_1 | cut -d ' ' -f 2)
docker commit fre_b_container_1 $TO_IMG

