# remove old gazebo cache file, so gazebo is forced to use the new height map.
rosrun virtual_maize_field generate_world.py \
--row_length 7 \
--rows_left 0 \
--rows_right 11 \
--row_segments straight \
--hole_prob 0.04 \
--hole_size_max 7 \
--litters 5 \
--weeds 5 \
--ghost_objects true \
--location_markers true
