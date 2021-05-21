#!/bin/bash
CONTAINERS=$(docker ps -a | tail -n +2 | sed 's/  */ /g')
if echo $CONTAINERS | grep -v fre_b_container_1 ; then
    echo "You don't have a default b_container present. Try starting the competition environment."
    exit 1
fi

function help() {
  echo "$0 <src> <dst>"
  echo "<src> : source folder for uploading to b container."
  echo "<dst> : location in b container you want it to end up in."
  exit 255
}

if [ -z "$1" ] ; then
   help
fi
if [ -z "$2" ] ; then
   help
fi

echo "Copying ${1} into current b container at ${2} ..."
if ! docker cp "${1}" "fre_b_container_1:${2}" ; then
  echo "Looks like your B container died... Starting it temporarily."
  docker start -a fre_b_container_1 &
  sleep 4
  docker cp "${1}" "fre_b_container_1:${2}"
fi

