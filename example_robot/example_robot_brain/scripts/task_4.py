#!/usr/bin/env python

from navigation import driver
import csv
import rospkg
import os

# open the provided map
pkg_path = rospkg.RosPack().get_path("virtual_maize_field")
map_path = os.path.join(pkg_path, "map/map.csv")
with open(map_path) as map_f:
    map_reader = csv.reader(map_f)

    print("map loaded")
    for line in map_reader:
        print("%s" % line)

# drive for 10 seconds
driver()
