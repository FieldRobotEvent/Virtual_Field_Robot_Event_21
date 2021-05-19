# For competitors
There are scripts set up to help you deploy containers:
* ./setup_competition_environment.sh <num> will deploy the containers in a format we expect to use in task <num>
* ./stop_competition_environment.sh <num> will stop all containers from this task. This should be generic, but just in case, there's a num flag too.
* ./edit_my_container.sh Creates a shell inside the currently running `fre_b_container_1` and allows editing from a terminal.
* ./save_my_container.sh Saves the currently running `fre_b_container_1` to the image file it came from.
* ./dump_my_container.sh <num> dumps a gzipped tarball of that container to b_task_<num>.tgz for upload.
* ./put_files_in_my_container.sh <src> <dst> allows you to copy files locally into the current b container for editing/saving.
* ./change_my_start_cmd.sh <cmd> Saves the current b_container to its image, but changes the CMD field to <cmd>.

TODO:
* ./upload_my_container.sh <num>

# Basic container usage
* Run ./setup_competition_environment.sh 1 to set up your containers.
* This will construct a new `b_task_1` image for you. If you are not writing a Dockerfile, this will be your target container.
* Intially, there is an `fre_b_container_1` running container that is spawned from this image.
* You can edit this container with ./edit_my_container.sh . This will create a shell for you inside the container for constructing it.
* Once you are happy with your code in the container, save it to the image with ./save_my_container.sh
* Should you want to copy code into your container, do ./put_files_in_my_container.sh <src> <dst> .
* As you can see from the Dockerfile, we are expecting the B container to start with the command:
** sh -c "roslaunch example_robot example_robot.launch --wait"
* You can edit this with the ./change_my_start_cmd.sh <cmd> script. (this will save to the image)
* If you then re-run ./setup_competition_environment.sh 1 , your container will start up in the configuration as expected in the competition.
* Edit your containers/images until you are happy with this.
* Once you are happy, either upload your container image to hub.docker.io and let the adjudicators know,
** or dump your image to a tarball with ./dump_my_container.sh <num>

# Tips and Hints
* Be careful to wait for your script to wait until the rosmaster is up. Due to the container spawning in (almost) parallel, there's a chance that B will come up before A is completely ready.


# How to Clean up
* ./cleanup_docker.sh can be used to clean images out.
* ./cleanup_docker.sh tidy is a safe command that will remove all unlinked images (and make filesystem space usage less)
* ./cleanup_docker.sh stop will stop all running containers in case of emergency/disaster
* ./cleanup_docker.sh rmall will stop and remove all containers. This will make all uncommitted information disappear, and so will prompt.
* ./cleanup_docker.sh nuke will remove all containers and images and wipe the slate clean. It will prompt before it does this.


# Task 1
* This task is all about driving through the rows. We expect to see you navigate the jackal robot through the crops using the associated sensors.

# Task 2
* This task is all about driving through the rows, but in a specified order.
* You can find that order in a file presented in:
** /catkin/src/Virtual_Field_Robot_Event/virtual_maize_field/map/driving_directions.txt
* Parse this file and take the specified corners at the ends of the rows.

# Task 3/4
* You can upload your own robot definition. This is a TODO!

# Task 3
* Task 3 is an observation task. Traverse the rows and find the weeds/trash, and return a map of locations.
* We are expecting you to output these locations to:
** /catkin/src/Virtual_Field_Robot_Event/virtual_maize_field/map/pred_map.csv

# Task 4
* Task 4 is an traversal task. We will provide you with a map of locations of weeds/trash, and you should move your robot to these locations and treat them
* We will give you a map of all the locations of all objects at
** /catkin/src/Virtual_Field_Robot_Event/virtual_maize_field/map/map.csv
* or
** /catkin/src/Virtual_Field_Robot_Event/virtual_maize_field/map/map.png
* Move the robot through the field and treat these objects.
