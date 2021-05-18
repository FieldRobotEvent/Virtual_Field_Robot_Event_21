# Building the containers

#For competitors
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

## a_container
1. Run `docker build <PATH TO FOLDER CALLED a_container> -t a_container`. Build the container and gives it `a_container` as name tag. 

# Running the containers
1. To start the a container, containing the simulation software, run the following command: `docker run -it -p 8080:8080 a_container`. Or run it as a deamon by adding the `-d` argument.
2. Open you browser and to go `localhost:8080` to view the gazebo web interface. 
3. Open a new terminal and and list all docker processes by typing `docker ps`
4. you can kill a docker process by typing `docker kill <CONTAINER ID>`

# cleaning up
* ./cleanup_docker.sh can be used to clean images out.
* ./cleanup_docker.sh tidy is a safe command that will remove all unlinked images (and make filesystem space usage less)
* ./cleanup_docker.sh stop will stop all running containers in case of emergency/disaster
* ./cleanup_docker.sh rmall will stop and remove all containers. This will make all uncommitted information disappear, and so will prompt.
* ./cleanup_docker.sh nuke will remove all containers and images and wipe the slate clean. It will prompt before it does this.
