#!/bin/bash

if [ -z "$1" ] ; then
  TASK="tidy"
  echo "Defaulting to $TASK"
else
TASK=$1
fi

if [ "$TASK" == "stop" ] ; then
  echo "Stopping all running containers."
  docker stop $(docker ps -q)
fi

if [ "$TASK" == "tidy" ] ; then
  echo "Removing all unlinked docker images."
  docker rmi $(docker images -q)
fi

if [ "$TASK" == "rmall" ] ; then
  echo "Stopping and removing all containers."
  echo "This may make you lose progress. ONLY do this if you are SURE you need to!"
  read -sp "Press return to continue."
  docker stop $(docker ps -q)
  docker rm $(docker ps -aq)
fi

if [ "$TASK" == "nuke" ] ; then
  echo "This may make you lose progress. ONLY do this if you are SURE you need to!"
  read -sp "Press return to continue."
  docker stop $(docker ps -q)
  docker rm $(docker ps -aq)
  docker rmi $(docker images -q)
fi
