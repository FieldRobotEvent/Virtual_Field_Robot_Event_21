
docker run -d \
    fieldrobotevent/a_container_2021 \
    --name fre_a_container_1 \
    -h acontainer \
      -v "./worlds:/catkin/src/Virtual_Field_Robot_Event/virtual_maize_field/worlds" \
      -v "./Media:/catkin/src/Virtual_Field_Robot_Event/virtual_maize_field/Media" \
      -v "./map:/catkin/src/Virtual_Field_Robot_Event/virtual_maize_field/map" \
      -v "./launch:/catkin/src/Virtual_Field_Robot_Event/virtual_maize_field/launch" \
      -v "/tmp/.X11-unix:/tmp/.X11-unix:rw" \
      -v "/tmp/.docker.xauth:/tmp/.docker.xauth:rw" \
    -e "DISPLAY=:1" \
    -e "NVIDIA_DRIVER_CAPABILITIES=all" \
    --runtime nvidia
