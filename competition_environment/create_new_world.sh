#!/bin/bash
CONTAINERS=$(docker ps -a | tail -n +2 | sed 's/  */ /g')
if echo $CONTAINERS | grep -v fre_a_container_1 ; then
    echo "You don't have an a_container present. Try starting the competition environment."
    exit 1
fi

#Tell me which task you're running and use that to generate a new world
TASK=$(docker inspect fre_a_container_1 | grep -o 'task_[1-4]' | uniq)
docker exec -it fre_a_container_1 /bin/bash -c "source /ros_entrypoint.sh && rosrun virtual_maize_field create_$TASK_mini.sh"
