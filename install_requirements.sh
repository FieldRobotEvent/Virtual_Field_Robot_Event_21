#!/bin/bash
#
# This file configures the working environment for the Field Robot Event
#
# Author: Thijs Ruigrok
# email: thijs.ruigrok@wur.nl

echo "Please wait while your working environment is setup"

# Change the workspace_root to the root of you workspace
workspace_root="$HOME/catkin_ws"

# install git and configure git
apt-get -y install git

# install ROS melodic
# =======================================
# your computer must accept packages from ros
sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
apt-get update

# install ros melodic
apt-get -y install ros-melodic-desktop-full

apt-get update
apt-get -y upgrade 

# needed for the jackal accessoires 
sudo apt-get -y install ros-melodic-pointgrey-camera-description
sudo apt-get -y install ros-melodic-robot-localization 
sudo apt-get -y install ros-melodic-twist-mux
sudo apt-get -y install ros-melodic-interactive-marker-twist-server
sudo apt-get -y install ros-melodic-hector-gazebo-plugins

# add ros to the bashrc
grep -q -F "source /opt/ros/melodic/setup.bash" ~/.bashrc || echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc

# automatically source the simple world workspace
grep -q -F "source $workspace_root/devel/setup.bash" ~/.bashrc || echo "source $workspace_root/devel/setup.bash" >> ~/.bashrc

