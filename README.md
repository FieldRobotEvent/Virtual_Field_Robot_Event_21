# Description
This folder contains all the components used in deploying the competition environment.

# Competition Environment
During the competition, there will be two containers - the A container, running rosmaster and gazebo, and the B container, running your code.
This allows you to have as much freedom as you desire in completing the tasks, without any risk of having mixed dependencies (such as ROS/ROS2) interfering with your solution.

You can find here the Dockerfiles used for creating the A container and some example B containers that could hypothetically be used to compete.

# Folder Structure
* a_container : Contains the Dockerfile used for generating the A container. This is for your reference, and is effectively read-only.
* a_container : Contains the Dockerfile used for generating the example B container. Please read this and use this for generation of your container image.
* task_1/2/3/4 : Each folder is used for the task competition environments. Each contains:
  * docker-compose.yml : The docker-compose.yml file that will be used to launch your container in a competition environment
  * map/world/launch folders : Folders that contain an example world used for competing

# Installation
* Run (or read and execute the commands in) the 'install.sh' command. This will put your user in the `docker` group. To make this change, you will need to restart.
* Be advised that this is a security risk, in that your user could gain root shell using the docker pipe this grants you access to. If you intend to use the machine you're installing on after this competition, consider removing the user from group `docker`.

# Example Scripts
There are scripts set up to help you deploy containers:
* ./start_competition_environment.sh <num> will deploy the containers in a format we expect to use in task <num>
* ./stop_competition_environment.sh <num> will stop all containers from this task. This should be generic, but just in case, there's a num flag too.
* ./edit_my_container.sh Creates a shell inside the currently running `fre_b_container_1` and allows editing from a terminal.
* ./save_my_container.sh Saves the currently running `fre_b_container_1` to the image file it came from.
* ./dump_my_container.sh <num> dumps a gzipped tarball of that container to b_task_<num>.tgz for upload.
* ./put_files_in_my_container.sh <src> <dst> allows you to copy files locally into the current b container for editing/saving.
* ./change_my_start_cmd.sh <cmd> Saves the current b_container to its image, but changes the CMD field to <cmd>.

TODO:
* ./upload_my_container.sh <num>

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


# Task 1
This task is all about basic navigation. We expect to see you navigate the jackal robot through the crops using the associated sensors. The robot has to drive through the curved row, into the next curved row and repeat this process till a 3-minute timer runs out, or till the robot has reached the end of the field. 
Details: https://www.fieldrobot.com/event/index.php/contest/task-1/

# Task 2
This advanced navigation task is all about driving through the rows according to a given pattern. E.g. 3L – 2L – 2R – 1R – 5L – F. You can find that order in a file presented in: 
  * /catkin/src/Virtual_Field_Robot_Event/virtual_maize_field/map/driving_directions.txt. 
Parse this file and take the specified turns at the headlands. The field contains straight rows with missing plants. 
Details: https://www.fieldrobot.com/event/index.php/contest/task-2/

# Task 3/4
* You can upload your own robot definition. This is a TODO!

# Task 3
Task 3 is a field mapping task. Traverse the rows and find the weeds/trash, and return a map of locations. The field contains straight rows with missing plants. On the headlands, two pillars, with a QR code are located as reference points. We will give you a file with their locations at 
  * /catkin/src/Virtual_Field_Robot_Event/virtual_maize_field/map/markers.csv. 
The weeds an trash needs to be mapped in the coordinate system of the two location markers. Your robot needs to make a .csv file with the locations of the weeds and the bottles/cans. This .csv file must be in the same format as this file: 
  * /catkin/src/Virtual_Field_Robot_Event/virtual_maize_field/map/example_pred_map.csv. 
We are expecting you to output your map to 
  * /catkin/src/Virtual_Field_Robot_Event/virtual_maize_field/map/pred_map.csv.

# Task 4
Task 4 is about removing objects. The field will, more or less, look the same as in task 3. We will provide you with a map of locations of weeds and trash, you should move your robot to these locations and pick up the objects. Your robot has to deliver the weeds on the headland of Location_marker_A. The bottles and cans must be delivered on the headland of Location_marker_B. A map of all the locations of all objects, including the two location markers, can be found at 
  * /catkin/src/Virtual_Field_Robot_Event/virtual_maize_field/map/map.csv 
and 
  * /catkin/src/Virtual_Field_Robot_Event/virtual_maize_field/map/map.png
