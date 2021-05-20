#!/usr/bin/env python

from navigation import driver
import csv

# open the provided map
with open('/virtual_field_robot_event/task_4/map/map.csv') as map_f:
    map_reader = csv.reader(map_f)
    
    print('map loaded')
    for line in map_reader:
        print('%s' % line)

# drive for 10 seconds
driver()

