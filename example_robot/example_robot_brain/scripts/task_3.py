#!/usr/bin/env python

from navigation import driver
from detection import obj_mapper
import csv
import rospkg
import rospy
import std_msgs.msg
import os

# open the location marker file
pkg_path = rospkg.RosPack().get_path("virtual_maize_field")
marker_path = os.path.join(pkg_path, "map/markers.csv")

with open(marker_path, "r") as markers_f:
    marker_reader = csv.reader(markers_f)

    print("Markers loaded:")
    for line in marker_reader:
        print("%s" % line)


detection_publisher = rospy.Publisher('fre_detections', std_msgs.msg.String)

# drive for 3 seconds
driver(3)

# report weed detection
print('report weed detection')
detection_publisher.publish(std_msgs.msg.String("weed"))


# drive for 3 seconds
driver(3)

# report litter detection
print('report litter detection')
detection_publisher.publish(std_msgs.msg.String("litter"))

# drive for 3 seconds
driver(3)


# detect weeds
weed_placements, litter_placements = obj_mapper()

# save the prediction map
out_map_path = os.path.join(pkg_path, "map/pred_map.csv")
with open(out_map_path, "w") as f:
    print("writing map")
    writer = csv.writer(f)
    header = ["X", "Y", "kind"]
    writer.writerow(header)

    for elm in weed_placements:
        writer.writerow([elm[0], elm[1], "weed"])

    for elm in litter_placements:
        writer.writerow([elm[0], elm[1], "litter"])
