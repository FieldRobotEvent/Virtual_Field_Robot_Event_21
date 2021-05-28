#!/bin/bash

#A simple script to stop and remove containers, as docker-compose down would
NETNAME=fre_default
A_NAME=fre_a_container_1
B_NAME=fre_b_container_1

if docker ps --format "{{.Names}}" | grep "$A_NAME" ; then
  docker stop "$A_NAME"
  docker rm "$A_NAME"
fi

if docker ps --format "{{.Names}}" | grep "$B_NAME" ; then
  docker stop "$B_NAME"
  docker rm "$B_NAME"
fi

if docker network ls --format "{{.Name}}" | grep "$NETNAME" ; then
  docker network rm "$NETNAME"
fi

