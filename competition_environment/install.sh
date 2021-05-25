#!/bin/bash
sudo apt-get update
sudo apt-get install git docker.io docker-compose

sudo gpasswd -a $USER docker
echo "Please now log out / restart to allow your new group permissions to take hold."
