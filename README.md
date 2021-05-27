# Virtual Field Robot Event 

<p float="left" align="middle">
  <img src="https://www.fieldrobot.com/event/wp-content/uploads/2021/01/FRE-logo-v02.png" width="250" style="margin: 10px;"> 
  <img src="https://www.wur.nl/upload/58340fb4-e33a-4d0b-af17-8d596fa93663_WUR_RGB_standard.png" width="250" style="margin: 10px;"> 
  <img src="https://www.uni-hohenheim.de/typo3conf/ext/uni_layout/Resources/Public/Images/uni-logo-en.svg" width="250" style="margin: 10px;">
</p>

This meta repository contains all the custom ROS packages needed for the FRE.

## ROS Packages
 - [Virtual Maize Field](virtual_maize_field/README.md)
 - [jackal_fre](jackal_fre/README.md)
 - [example_robot](example_robot/README.md)
 - [competition_environment](competition_environment/README.md)
 
## Short task descriptions
The tasks are from https://www.fieldrobot.com/event/index.php/contest/. The simulated world constructors can be found in `virtual_maize_field/scripts`. The [Virtual Maize Field README](virtual_maize_field/README.md) gives a description of the world constructors and instructions on how to use these. 

| Task | Description |
|:---- |:----------- |
|*Task_1*|The field contains curved rows. The robot has to drive through the row, into the next row and repeat this process till a 3-minute timer runs out, or till the robot has reached the end of the field. Details: https://www.fieldrobot.com/event/index.php/contest/task-1/|
|*Task_2*|The field contains straight rows with missing plants. The Robot has to drive through the rows according to a given pattern. E.g. 3L – 2L – 2R – 1R – 5L – F. Details: https://www.fieldrobot.com/event/index.php/contest/task-2/|
|*Task_3*|The field contains straight rows with missing plants. On the headland, two pillars, with a QR code are located. The QR code on one pillar says `Location_marker_A`, and the QR code on the other pillar says `Location_marker_B`. The location of these pillars is given by the map generator in the file `virtual_maize_field/map/markers.csv`. Throughout the field, there are 4 or 5 weeds and 4 or 5 cans/bottles. These objects are “ghost” objects, meaning that they are visible, but they don’t have a collision box and cannot be moved. These objects need to be mapped in the coordinate system of the two location markers. Afterwards, your robot needs to make a .csv file with the locations of the weeds and the bottles/cans. This .csv file must be in the same format as the file located in `virtual_maize_field/map/example_pred_map.csv`. Using the script `virtual_maize_field/scripts/compare_maps.py`, the locations of your detections can be compared to the ground truth locations of the objects, and you will get a score for your map. In the location `virtual_maize_field/map/evaluation_map.png` you will find a map containing your detections, the ground truth detections, and your map score. Details: https://www.fieldrobot.com/event/index.php/contest/task-3/|
|*Task_4*|The field looks the same as in task 3, however, the weeds, cans, and bottles have a collision box and can be moved by your robot. At the beginning of the task, you will get a map of the field. The map is located in `virtual_maize_field/map/map.csv`, and `virtual_maize_field/map/map.png`. The map contains the ground truth location of all the plants, location markers, weeds, cans, and bottles. You can use this map for optimal path planning. During this task, the robot has to pick up the weeds and drop them on the headland of `Location_marker_A`. The bottles and cans also need to be picked up and dropped on the headland of `Location_marker_B`. Details: https://www.fieldrobot.com/event/index.php/contest/task-4/|

## FRE Setup - Installation
1.	Get a computer with ubuntu 18.04*. If you do not have a ubuntu 18.04 machine, you can install a virtual machine following the bullet points below. If you already have an ubuntu 18.04 machine you can skip to step 2.
	* Download and install VM ware from the VMware website: https://my.vmware.com/en/web/vmware/downloads/details?downloadGroup=PLAYER-1600&productId=1039&rPId=51984. Download "VMware Workstation 16.0.0 Player for Windows" if you are using a windows computer. Within VMware we install a virtual Linux computer. 
	* Create a new virtual machine using VMware
		* Change the configuration about the number of CPU cores used, the max number of RAM to use and the max allowable hard disk space. 
	* Select ubuntu 18.04 as iso. https://releases.ubuntu.com/18.04.5/ubuntu-18.04.5-desktop-amd64.iso 
2.	Open a terminal(Ctrl + Alt + T) and type `sudo apt install git` to install git
3.	Create a catkin workspace and move into it `mkdir -p ~/catkin_ws/src && cd ~/catkin_ws/src`.
4.	While in this folder, clone the FRE git repository by typing `git clone https://github.com/FieldRobotEvent/Virtual_Field_Robot_Event` in the terminal. This will create a folder  named ‘Virtual_Field_Robot_Event’, containing all the files need to run the simulation.
5.	Install all required software by typing `sudo bash -i ~/catkin_ws/src/Virtual_Field_Robot_Event/install_requirements.sh`.
6.	After the installation type `source ~/.bashrc`
7.	Run `cd ~/catkin_ws && catkin_make && source ~/.bashrc` in the terminal.
8.	You can now create a new simulation world by running `rosrun virtual_maize_field create_task_1_mini.sh`. 
9.	You can run the simulation by running `roslaunch virtual_maize_field jackal_simulation.launch`. 
10.	You can control the robot, and see the sensor output using `roslaunch jackal_viz view_robot.launch`. If you encounter any errors, we refer you to the troubleshooting section. 
11.	The robot used in the simulation is the Clearpath Jackal, you can find detailed instructions and documentation at http://www.clearpathrobotics.com/assets/guides/kinetic/jackal/simulation.html. Be aware that the Jackal comes with a GPS but that the use of a GNSS receiver is not allowed except for the Free Style in Task 5. The focus for the other tasks in terms of localisation shall be on relative positioning and sensor based behaviours.

*) Feel free to use other versions of Ubuntu, ROS, packages and other software. We have only tested the above versions and software.

### Trouble shooting
* If you encounter the error: 'VMware: vmw_ioctl_command error Invalid argument.’ When launching gazebo. Then you should type `echo "export SVGA_VGPU10=0" >> ~/.profile` in the terminal and reboot your (virtual) machine. 
* If you encounter the error ‘Error in REST request’ when launching gazebo. Then you should open `~/.ignition/fuel/config.yaml` and change the line: ‘url: https://api.ignitionfuel.org’ to ‘url:  https://api.ignitionrobotics.org’.
* If the lidar data on the topic `front/scan` only returns ranges with the value `inf`, even though in simulation the lidar should ‘see’ certain objects within its range, you have to run `export LIBGL_ALWAYS_SOFTWARE=1` in the terminal in which you launch gazebo. You have to run this command before starting gazebo. This solves the problem with the lidar, but might have some consequences on the rendering speed of gazebo. 










