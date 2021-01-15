#!/bin/bash
#
# This file configures the working environment for the Field Robot Event
# run this file by typing 'sudo sh install_required_software.sh'
#
# Author: Thijs Ruigrok
# email: thijs.ruigrok@wur.nl

echo "Please wait while your working environment is setup"

# install git and configure git
apt-get -y install git

git clone https://git.wur.nl/ruigr004/fre_virtual_event.git

# install ROS melodic
# =======================================
# your computer must accept packages from ros
sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
apt-get update

# install ros melodic
apt-get -y install ros-melodic-desktop-full

# install the jackal software
sudo apt-get -y install ros-melodic-jackal-simulator ros-melodic-jackal-desktop ros-melodic-jackal-navigation

apt-get update
apt-get -y upgrade 

# add ros to the bashrc
grep -q -F "source /opt/ros/melodic/setup.bash" ~/.bashrc || echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc

# add gazebo model path to the bashrc
grep -q -F "export GAZEBO_MODEL_PATH=~/fre_virtual_event/src/simple_world/:\$GAZEBO_MODEL_PATH" ~/.bashrc || echo "export GAZEBO_MODEL_PATH=~/fre_virtual_event/src/simple_world/:\$GAZEBO_MODEL_PATH" >> ~/.bashrc

# make the simple world
cd ~/fre_virtual_event
catkin_make 

# automatically source the simple world workspace
grep -q -F "source ~/fre_virtual_event/devel/setup.bash" ~/.bashrc || echo "source ~/fre_virtual_event/devel/setup.bash" >> ~/.bashrc

# update the current terminal with the newly added settings
source ~/.bashrc

