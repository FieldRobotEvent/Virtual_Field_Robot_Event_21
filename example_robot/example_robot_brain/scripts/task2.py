#!/usr/bin/env python

from navigation import driver

# read the driving idrections from the file
with open('task_2/map/driving_directions.txt') as direction_f:
    directions = direction_f.readline()
    
print('driving directions are: %s' % directions)

driver()
