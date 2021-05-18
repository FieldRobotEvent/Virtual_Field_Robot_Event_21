FROM ros:melodic-robot

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

#build requirements for gzweb
# RUN apt-get update && \
#   apt-get -y install wget gazebo9 git libgazebo9-dev libjansson-dev libboost-dev && \
#   apt-get -y install imagemagick libtinyxml-dev mercurial cmake build-essential && \
#   rm -rf /var/lib/apt/lists/*

# RUN wget -q -O- https://deb.nodesource.com/setup_10.x | bash && \
#   apt-get -y install nodejs && \
#   rm -rf /var/lib/apt/lists/*

#Make the code required for the container and add it to the entrypoint
RUN mkdir -p /catkin/src && cd /catkin/src && git clone https://github.com/FieldRobotEvent/Virtual_Field_Robot_Event.git
RUN bash -c "source /opt/ros/melodic/setup.bash && cd /catkin && catkin_make"
RUN sed -i 's|^\(source .*\)|\1 \&\& source /catkin/devel/setup.bash|g' /ros_entrypoint.sh

#Build gzweb
# RUN git clone -b gzweb_1.4.1 --single-branch https://github.com/osrf/gzweb
# RUN . /usr/share/gazebo/setup.sh 
# RUN mkdir -p /gzweb/http/client/assets/ && \
#  cp -r /catkin/src/Virtual_Field_Robot_Event/virtual_maize_field/models/* /gzweb/http/client/assets/ && \
#  cp -r /catkin/src/Virtual_Field_Robot_Event/jackal_fre/* /gzweb/http/client/assets/
# RUN cd gzweb && npm run deploy --- -m local

#Map volume location
VOLUME ["/catkin/src/Virtual_Field_Robot_Event/virtual_maize_field/map","/catkin/src/Virtual_Field_Robot_Event/virtual_maize_field/worlds"]

EXPOSE 8080 11345

# install some x stuff
RUN apt-get update && \
  apt-get -y install xvfb

# Create the maize world and launch it
ENV LIBGL_ALWAYS_SOFTWARE=1
CMD sh -c "rosrun virtual_maize_field create_task_1_mini.sh" && \
sh -c "Xvfb -shmem -screen 0 1280x1024x24" & \
sh -c "roscore"

# && \ cd /gzweb && npm start
# sh -c "roslaunch virtual_maize_field jackal_simulation.launch gui:=false verbose:=true" & \

# the problem of th enot working models is potentially related to a mistake in the installation in which the models are copied to the "client/assets" folder. 
# https://answers.gazebosim.org//question/17367/simulated-robot-model-randomly-appears-in-gzweb-gui/
# http://gazebosim.org/gzweb#install-collapse-1 
