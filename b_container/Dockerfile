# start with a ros-melodic installation
FROM ros:melodic-robot

# clone the git repository from your robot into your catkin workspace
RUN mkdir -p /catkin/src && cd /catkin/src && git clone https://github.com/FieldRobotEvent/Virtual_Field_Robot_Event.git

# Catkin_make your package and source the setup.bash
RUN bash -c "source /opt/ros/melodic/setup.bash && cd /catkin && catkin_make"

# add the setup.bash to your ros entrypoint (needed by docker)
RUN sed -i 's|^\(source .*\)|\1 \&\& source /catkin/devel/setup.bash|g' /ros_entrypoint.sh

#Mountable location that contains map data for tasks 2/3 and where we expect pred_map.csv to go (in task 2)
VOLUME ["/catkin/src/Virtual_Field_Robot_Event/virtual_maize_field/map"]

# setup the ros master to communicate with the gazebo container. 
ENV ROS_MASTER_URI=http://acontainer:11311

# launch your robot. The wait command ensures that this launch file waits for the gazebo container to start the ros server. 
CMD sh -c "roslaunch example_robot example_robot.launch --wait"


