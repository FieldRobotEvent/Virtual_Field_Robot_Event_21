#!/bin/bash

if [ -z "$1" ] ; then
  $1="tidy"
  echo "Defaulting to $1"
fi

if [ "$1" == "stop" ] ; then
  echo "Stopping all running containers."
  docker stop $(docker ps -q)
fi

if [ "$1" == "tidy" ] ; then
  echo "Removing all unlinked docker images."
  docker rmi $(docker images -q)
fi

if [ "$1" == "rmall" ] ; then
  echo "Stopping and removing all containers."
  echo "This may make you lose progress. ONLY do this if you are SURE you need to!"
  read -sp "Press return to continue."
  docker stop $(docker ps -q)
  docker rm $(docker ps -aq)
fi

if [ "$1" == "nuke" ] ; then
  echo "This may make you lose progress. ONLY do this if you are SURE you need to!"
  read -sp "Press return to continue."
  docker stop $(docker ps -q)
  docker rm $(docker ps -aq)
  docker rmi $(docker images -q)
fi
