FROM ros:melodic-robot

LABEL org.opencontainers.image.authors="Field Robot Event Team <fieldrobot.events@wur.nl>"

#Competition dependencies
RUN apt-get update && \
  apt-get -y install ros-melodic-desktop-full ros-melodic-pointgrey-camera-description && \
  apt-get -y install ros-melodic-robot-localization ros-melodic-twist-mux && \
  apt-get -y install ros-melodic-interactive-marker-twist-server ros-melodic-hector-gazebo-plugins && \
  apt-get -y install git screen python-pip python3-pip && \
  rm -rf /var/lib/apt/lists/*
RUN pip install -U pip && pip3 install -U pip
RUN pip install -U jinja2 rospkg
RUN pip3 install numpy jinja2 rospkg opencv-python matplotlib shapely

#Plain gazebo requirements
RUN apt-get update && \
  apt-get -y install ros-melodic-gazebo-ros-pkgs && \
  apt-get -y install ros-melodic-gazebo-ros-control && \
  rm -rf /var/lib/apt/lists/*

## deprecated ##
# build requirements for gzweb
# RUN apt-get update && \
#   apt-get -y install wget gazebo9 git libgazebo9-dev libjansson-dev libboost-dev && \
#   apt-get -y install imagemagick libtinyxml-dev mercurial cmake build-essential && \
#   rm -rf /var/lib/apt/lists/*
#
# RUN wget -q -O- https://deb.nodesource.com/setup_10.x | bash && \
#   apt-get -y install nodejs && \
#   rm -rf /var/lib/apt/lists/*
#################

#Make the code required for the container and add it to the entrypoint
RUN mkdir -p /catkin/src && cd /catkin/src && git clone https://github.com/FieldRobotEvent/Virtual_Field_Robot_Event.git && rm -rf Virtual_Field_Robot_Event/example_robot
RUN bash -c "source /opt/ros/melodic/setup.bash && cd /catkin && catkin_make"
RUN sed -i 's|^\(source .*\)|\1 \&\& source /catkin/devel/setup.bash|g' /ros_entrypoint.sh

## deprecated ##
#Build gzweb
# RUN git clone -b gzweb_1.4.1 --single-branch https://github.com/osrf/gzweb
# RUN . /usr/share/gazebo/setup.sh 
# RUN mkdir -p /gzweb/http/client/assets/ && \
#  cp -r /catkin/src/Virtual_Field_Robot_Event/virtual_maize_field/models/* /gzweb/http/client/assets/ && \
#  cp -r /catkin/src/Virtual_Field_Robot_Event/jackal_fre/* /gzweb/http/client/assets/
# RUN cd gzweb && npm run deploy --- -m local
#################

#Map volume location
VOLUME ["/catkin/src/Virtual_Field_Robot_Event/virtual_maize_field/map"]
VOLUME ["/catkin/src/Virtual_Field_Robot_Event/virtual_maize_field/Media"]
VOLUME ["/catkin/src/Virtual_Field_Robot_Event/virtual_maize_field/worlds"]
VOLUME ["/catkin/src/Virtual_Field_Robot_Event/virtual_maize_field/launch"]
VOLUME ["/catkin/src/my_robot"]
VOLUME ["/tmp/.X11-unix"]
VOLUME ["/tmp/.docker.xauth"]

EXPOSE 8080 11345

# Set env vars for x forwarding
ENV LIBGL_ALWAYS_SOFTWARE=1
ENV XAUTHORITY=/tmp/.docker.xauth
ENV DISPLAY=:0
ENV QT_X11_NO_MITSHM=1

# Launch the simulation
# task 1 and 2
CMD sh -c "roslaunch virtual_maize_field jackal_simulation.launch paused:=true"

# task 3 and 4
# CMD sh -c "roslaunch virtual_maize_field simulation.launch paused:=true"

## deprecated ##
# && \ cd /gzweb && npm start
# sh -c "roslaunch virtual_maize_field jackal_simulation.launch gui:=false verbose:=true" & \
# 
# the problem of the not working models is potentially related to a mistake in the installation in which the models are copied to the "client/assets" folder. 
# https://answers.gazebosim.org//question/17367/simulated-robot-model-randomly-appears-in-gzweb-gui/
# http://gazebosim.org/gzweb#install-collapse-1 
#################
