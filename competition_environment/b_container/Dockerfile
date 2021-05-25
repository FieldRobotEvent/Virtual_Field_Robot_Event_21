# start with a ros-melodic installation
FROM ros:melodic-robot

# Robot dependencies (this is the software required by your own robot)
RUN apt-get update && \
  apt-get -y install ros-melodic-desktop-full ros-melodic-pointgrey-camera-description && \
  apt-get -y install ros-melodic-robot-localization ros-melodic-twist-mux && \
  apt-get -y install ros-melodic-interactive-marker-twist-server ros-melodic-hector-gazebo-plugins && \
  rm -rf /var/lib/apt/lists/*

# clone the git repository from your robot into your catkin workspace
RUN mkdir -p /catkin/src && cd /catkin/src && git clone https://github.com/FieldRobotEvent/Virtual_Field_Robot_Event.git
# Catkin_make your package and source the setup.bash
RUN bash -c "source /opt/ros/melodic/setup.bash && cd /catkin && catkin_make"

# Example of cloning just one folder and then making it
# RUN mkdir -p /catkin/src/Virtual_Field_Robot_Event && cd /catkin/src/Virtual_Field_Robot_Event && git init && git remote add origin https://github.com/FieldRobotEvent/Virtual_Field_Robot_Event && git fetch origin && git checkout origin/master -- virtual_maize_field
# RUN bash -c "source /opt/ros/melodic/setup.bash && cd /catkin && catkin_make"

# add the setup.bash to your ros entrypoint (needed by docker)
RUN sed -i 's|^\(source .*\)|\1 \&\& source /catkin/devel/setup.bash|g' /ros_entrypoint.sh

#Mountable location that contains map data for tasks 2/3 and where we expect pred_map.csv to go (in task 2)
VOLUME ["/catkin/src/Virtual_Field_Robot_Event/virtual_maize_field/map"]
VOLUME ["/catkin/src/Virtual_Field_Robot_Event/virtual_maize_field/launch"]

# setup the ros master to communicate with the gazebo container. 
ENV ROS_MASTER_URI=http://acontainer:11311

# launch your robot. The wait command ensures that this launch file waits for the gazebo container to start the ros server. 

# task 1
CMD sh -c "roslaunch example_robot_brain task_1.launch --wait --screen"

# task 2
# CMD sh -c "roslaunch example_robot_brain task_2.launch --wait --screen"

# task 3
# CMD sh -c "roslaunch example_robot_brain task_3.launch --wait --screen"

# task 4
# CMD sh -c "roslaunch example_robot_brain task_4.launch --wait --screen"


