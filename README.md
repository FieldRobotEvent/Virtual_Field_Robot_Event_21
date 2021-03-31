# Building the containers
## a_container
1. Run `docker build <PATH TO FOLDER CALLED a_container> -t a_container`. Build the container and gives it `a_container` as name tag. 

# Running the containers
1. To start the a container, containing the simulation software, run the following command: `docker run -it -p 8080:8080 a_container`. Or run it as a deamon by adding the `-d` argument.
2. Open you browser and to go `localhost:8080` to view the gazebo web interface. 
3. Open a new terminal and and list all docker processes by typing `docker ps`
4. you can kill a docker process by typing `docker kill <CONTAINER ID>`

# cleaning up
1. List all docker images by running `docker images -a`
TODO 2. Remove a docker image by running `
3. Remove all docker images by running: `docker rmi -f $(docker images -a -q)`


4. remove all containers by running: `docker rm $(docker ps -a -f status=exited -q)`
