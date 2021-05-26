# Description
This folder contains all the components used in deploying the competition environment.

# Competition Environment
During the competition, there will be two containers - the A container, running rosmaster and gazebo, and the B container, running your code.
This allows you to have as much freedom as you desire in completing the tasks, without any risk of having mixed dependencies (such as ROS/ROS2) interfering with your solution.

You can find here the Dockerfiles used for creating the A container and some example B containers that could hypothetically be used to compete.

From the B container, the A container rosmaster is present at `http://acontainer:11311`.

For task 1 and 2, the a_container launches the robot model. You only need to communicate with this robot from the B container.

For task 3 and 4 you need to spawn your own robot model in addition to communicating with it.

For the event we expect you to deliver a docker container for each task. During the event we will start the a_container with the simulation world in paused mode and we will start the b_container_<task> that you provided for that specific task. We assume that your b_container automatically starts all your robot code. After startup, we will press the play button in the gazebo GUI, to start the simulation. We then expect the robot to start driving. So you must build your b_container in such a manner that the robot starts to drive when the simulation is started. 

# Folder Structure
* a_container : Contains the Dockerfile used for generating the A container. This is for your reference, and is effectively read-only.
* b_container : Contains the Dockerfile used for generating the example B container. Please read this and use this for generation of your container image.
* task_1/2/3/4 : Each folder is used for the task competition environments. Each contains:
  * docker-compose.yml : The docker-compose.yml file that will be used to launch your container in a competition environment
  * map/world/launch folders : Folders that contain an example world used for competing

# Installation
* Run (or read and execute the commands in) the 'install.sh' command. This will put your user in the `docker` group. To make this change, you will need to restart.
* Be advised that this is a security risk, in that your user could gain root shell using the docker pipe this grants you access to.
  * If you intend to use the machine you're installing on after this competition, consider removing the user from group `docker`.

# Example Scripts
There are scripts provided to help you deploy containers:
* ./start_competition_environment.sh <num> will deploy the containers in a format we expect to use in task <num>
* ./stop_competition_environment.sh <num> will stop all containers from this task. This should be generic, but just in case, there's a num flag too.
* ./edit_my_container.sh Creates a shell inside the currently running `fre_b_container_1` and allows editing from a terminal.
* ./save_my_container.sh Saves the currently running `fre_b_container_1` to the image file it came from.
* ./dump_my_container.sh <num> dumps a gzipped tarball of that container to b_task_<num>.tgz for upload.
* ./put_files_in_my_container.sh <src> <dst> allows you to copy files locally into the current b container for editing/saving.
* ./change_my_start_cmd.sh <cmd> Saves the current b_container to its image, but changes the CMD field to <cmd>.

TODO:
* ./upload_my_container.sh <num> Upload your container to dockerhub.

# Basic container usage
* Run ./start_competition_environment.sh 1 to set up your containers.
* This will construct a new `b_task_1` image for you. If you are not writing a Dockerfile, this will be your target container.
* Intially, there is an `fre_b_container_1` running container that is spawned from this image.
* You can edit this container with ./edit_my_container.sh . This will create a shell for you inside the container for constructing it.
* Once you are happy with your code in the container, save it to the image with ./save_my_container.sh
* Should you want to copy code into your container, do ./put_files_in_my_container.sh <src> <dst> .
* As you can see from the Dockerfile, we are expecting the B container to start with the command:
  * sh -c "roslaunch example_robot example_robot.launch --wait"
* You can edit this with the ./change_my_start_cmd.sh <cmd> script. (this will save to the image)
* If you then re-run ./setup_competition_environment.sh 1 , your container will start up in the configuration as expected in the competition.
* Edit your containers/images until you are happy with this.
* Once you are happy, either upload your container image to hub.docker.io and let the adjudicators know,
  * or dump your image to a tarball with ./dump_my_container.sh <num>

# Example robot tutorial
This is not a tutorial on docker, but instead is focused on how to implement your robot in our docker environment. When you want to know more about docker we recommend you to search for a docker tutorial. 

During this tutorial we will use the example_robot package from https://github.com/FieldRobotEvent/Virtual_Field_Robot_Event/tree/master/example_robot. This package contains a robot that can perform all 4 tasks of the event. This includes reading the driving directions for task 2, reading the location marker locations for task 3 and outputting a detection map and reading the entire field map for task 4. Please have a look at this package to see how all features are implemented. When looking at the code, also note that you can probably do better and write a robot program that can score more points. 

## Create a b_container. 
This container has all the software needed to run your robot software. In the folder `b_container` you find an example Dockerfile. This file contains all the instructions needed to build a docker image for the example robot. Please have a look at this file. 

In the first line, a readily made ros-melodic image is pulled from dockerhub. This image already contains a full installation of  Linux, Ubuntu and ROS melodic. After pulling this image, some more dependencies are installed. Note that regular linux commands are used, preceded by the `RUN` tag.  Furthermore, the code for the example robot is pulled from github. Some external volumes are mounted, that are used to provide your robot with information of the map of the field and its spawning location. Finally the field ends in a start command. When starting the docker container, the command after the CMD tag is run. The container stays alive until this command finishes. So if you do not supply a command, or if the command fails to execute, your container will die. 

## Make a task specific container
For each task you are expected to deliver a docker container. These containers can be completely independent of each-other. However, it is likely that internally you use the same container for every task, but with a different start command. Instead of making a completely new container from scratch, you can also just change the start command. To do this, follow the following steps:

First, start the competition environment for your task, e.g. task 2 by running `bash start_competition_environment.sh 2`. This command will launch the a_container(simulation container) and the b_container(robot container) for task 2. If the b_container for this task does not exist yet, it will create one, based on the dockerfile located in `/b_container` and name this container `b_task_2`. However note that the dockerfile in the b_container directory ends with a launch command to start task 1. This is of course undesired for task 2.

While this container is active, we can change the start CMD by running the command `bash change_my_start_cmd.sh "sh -c \"<my launch command>""` .  To change the start command to start the example robot for task 2, use the following command: `bash change_my_start_cmd.sh "sh -c \"roslaunch example_robot_brain task_2.launch --wait –screen\""`.  The container named b_task_2 will now be equipped with this start command. 

Now stop the competition environment by running `bash stop_competition_environment.sh 2`

start the competition environment again for task 2 by running `bash start_competition_environment.sh 2`. 

When everything works correctly you should see that the robot starts to drive when you press the play button in the gazebo GUI.  To see the terminal output of your robot code, run the command `docker logs fre_b_container_1`. 

## Add your custom robot model to the simulation for task 3 and 4.
Spawning a robot from the b container in the a_container works out of the box. The sensors are correctly modeled and the control plugins are also correctly loaded. However, the visual part of the robot is not correctly loaded into gazebo because it cannot access the mesh files located on the b_container. This should not be a problem when your robot does not contains meshes. 

To correctly load the visual part of the robot, you need to provide these files to the a_container. 
In the `task_3` folder, there is a folder named `my_robot`. This folder is mounted in a_container, and the packages in this folder are added to the workspace. In the `my_robot` folder you have to place your robot description. Not the entire packages are needed, you only have to copy the pakcage.xml, CmakeLists.txt and and mesh folder. However the other folders may also be added. You can copy these files from the `example_robot_description`. For the example robot we also also need to copy the visual meshes from the lidar form `example_lms1xx`. The structure now looks as follows (an copy of a correct version of this folder is show in the `task_3_example_robot` folder):
```
<task_3>
├──launch
├──map
├──…..
└──my_robot
   └──example_robot_description
      ├──meshes
      ├──CMakeLists.txt
      ├──package.xml
   └──example_lms1xx
      ├──meshes
      ├──CMakeLists.txt
      ├──package.xml
```

When you want to launch task 3 for the example robot, you need to change the start command of the b_container to `roslaunch example_robot_brain task_2.launch --wait –screen`. How to do this is explained in the section above. 

When starting the competition environment for the example robot, you will see that the robot starts do drive. Afterwards, the robot will output a detection map of the field in the location `task_3/map/pre_map.csv`.

## Submit your robot container to the organization.
TODO

# Tips and Hints
* Be careful to wait for your script to wait until the rosmaster is up. Due to the container spawning in (almost) parallel, there's a chance that B will come up before A is completely ready.

# Running the containers
1. To start the a container, containing the simulation software, run the following command: `docker run -it -p 8080:8080 a_container`. Or run it as a deamon by adding the `-d` argument.
2. Open a new terminal and and list all docker processes by typing `docker ps`
3. you can kill a docker process by typing `docker kill <CONTAINER ID>`

# How to Clean up
* `./cleanup_docker.sh` can be used to clean images out.
* `./cleanup_docker.sh tidy` is a safe command that will remove all unlinked images (and make filesystem space usage less)
* `./cleanup_docker.sh stop` will stop all running containers in case of emergency/disaster
* `./cleanup_docker.sh rmall` will stop and remove all containers. This will make all uncommitted information disappear, and so will prompt.
* `./cleanup_docker.sh nuke` will remove all containers and images and wipe the slate clean. It will prompt before it does this.

# Task Descriptions

## Task 1
This task is all about basic navigation. We expect to see you navigate the jackal robot through the crops using the associated sensors. The robot has to drive through the curved row, into the next curved row and repeat this process till a 3-minute timer runs out, or till the robot has reached the end of the field. 
Details: https://www.fieldrobot.com/event/index.php/contest/task-1/

## Task 2
This advanced navigation task is all about driving through the rows according to a given pattern. E.g. 3L – 2L – 2R – 1R – 5L – F. You can find that order in a file presented in: 
  * /catkin/src/Virtual_Field_Robot_Event/virtual_maize_field/map/driving_directions.txt. 
Parse this file and take the specified turns at the headlands. The field contains straight rows with missing plants. 
Details: https://www.fieldrobot.com/event/index.php/contest/task-2/

## Task 3
Task 3 is a field mapping task. Traverse the rows and find the weeds/trash, and return a map of locations. The field contains straight rows with missing plants. On the headlands, two pillars, with a QR code are located as reference points. We will give you a file with their locations at 
  * /catkin/src/Virtual_Field_Robot_Event/virtual_maize_field/map/markers.csv. 
The weeds an trash needs to be mapped in the coordinate system of the two location markers. Your robot needs to make a .csv file with the locations of the weeds and the bottles/cans. This .csv file must be in the same format as this file: 
  * /catkin/src/Virtual_Field_Robot_Event/virtual_maize_field/map/example_pred_map.csv. 
We are expecting you to output your map to 
  * /catkin/src/Virtual_Field_Robot_Event/virtual_maize_field/map/pred_map.csv.

## Task 4
Task 4 is about removing objects. The field will, more or less, look the same as in task 3. We will provide you with a map of locations of weeds and trash, you should move your robot to these locations and pick up the objects. Your robot has to deliver the weeds on the headland of Location_marker_A. The bottles and cans must be delivered on the headland of Location_marker_B. A map of all the locations of all objects, including the two location markers, can be found at 
  * /catkin/src/Virtual_Field_Robot_Event/virtual_maize_field/map/map.csv 
and 
  * /catkin/src/Virtual_Field_Robot_Event/virtual_maize_field/map/map.png
