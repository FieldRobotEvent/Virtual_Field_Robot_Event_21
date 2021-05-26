#!/usr/bin/env python

from navigation import driver
import rospkg
import os

# read the driving idrections from the file
pkg_path = rospkg.RosPack().get_path("virtual_maize_field")
dp_path = os.path.join(pkg_path, "map/driving_pattern.txt")

with open(dp_path) as direction_f:
    directions = direction_f.readline()

print("driving directions are: %s" % directions)

driver()
