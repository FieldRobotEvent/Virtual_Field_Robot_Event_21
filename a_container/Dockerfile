FROM ros:melodic-robot

# Install turtlebot packages
RUN apt-get update && apt-get install -y \
      ros-${ROS_DISTRO}-ros-tutorials \
      ros-${ROS_DISTRO}-common-tutorials \
      ros-melodic-turtlebot3-*

#Plain gazebo requirements
RUN apt-get update && \
  apt-get -y install ros-melodic-gazebo-ros-pkgs && \
  apt-get -y install ros-melodic-gazebo-ros-control && \
  rm -rf /var/lib/apt/lists/*

#build requirements for gzweb
RUN apt-get update && \
  apt-get -y install wget gazebo9 git libgazebo9-dev libjansson-dev libboost-dev && \
  apt-get -y install imagemagick libtinyxml-dev mercurial cmake build-essential && \
  rm -rf /var/lib/apt/lists/*

#RUN wget -q -O- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
#RUN . /root/.bashrc && nvm install 6
#RUN wget -q -O- https://deb.nodesource.com/setup_6.x | bash && \
#  apt-get -y install npm nodejs node-gyp nodejs-dev libssl1.0-dev && \
#  rm -rf /var/lib/apt/lists/*
RUN wget -q -O- https://deb.nodesource.com/setup_10.x | bash && \
  apt-get -y install nodejs && \
  rm -rf /var/lib/apt/lists/*

#Build gzweb
RUN git clone -b gzweb_1.4.1 --single-branch https://github.com/osrf/gzweb
RUN . /usr/share/gazebo/setup.sh 
RUN cd gzweb && npm run deploy --- -m -t
# RUN . /usr/share/gazebo/setup.sh && cd gzweb && npm run deploy --- -m
# RUN . /usr/share/gazebo/setup.sh && cd gzweb && npm run deploy --- -m local
#RUN bash -c "source /root/.bashrc && source /usr/share/gazebo/setup.sh && ls"

#Map volume location
VOLUME ["/catkin/src/Virtual_Field_Robot_Event/virtual_maize_field/map"]
VOLUME ["/catkin/src/Virtual_Field_Robot_Event/virtual_maize_field/Media"]
VOLUME ["/catkin/src/Virtual_Field_Robot_Event/virtual_maize_field/worlds"]

EXPOSE 8080 11345

# launch turtlebot and print some gazebo stuff
ENV TURTLEBOT3_MODEL=burger
CMD sh -c "echo TURTLEBOT3_MODEL: $TURTLEBOT3_MODEL" & \
  sh -c "echo gazebo model path: $GAZEBO_MODEL_PATH" & \
  sh -c "echo Version 9"& \
  roslaunch turtlebot3_gazebo turtlebot3_empty_world.launch gui:=false verbose:=true & \
  cd /gzweb && npm start

# the problem of th enot working models is potentially related to a mistake in the installation in which the models are copied to the "client/assets" folder. 
# https://answers.gazebosim.org//question/17367/simulated-robot-model-randomly-appears-in-gzweb-gui/
# http://gazebosim.org/gzweb#install-collapse-1 
