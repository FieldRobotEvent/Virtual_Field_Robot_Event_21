cmake_minimum_required(VERSION 3.0.2)
project(wurking_jackal_lms1xx)

find_package(catkin REQUIRED COMPONENTS roslaunch)

catkin_package()

install(DIRECTORY meshes launch urdf
  DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION}
)


