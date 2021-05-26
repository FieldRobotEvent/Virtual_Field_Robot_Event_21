#!/usr/bin/env python
# from http://wiki.ros.org/ROS/Tutorials/WritingPublisherSubscriber%28python%29

import rospy
from geometry_msgs.msg import Twist

# a very simple script that just sends the robot forwards for 10 seconds.
# We expect that you can come up with a better navigation algorithm
def driver():
    print("starting to drive")

    pub = rospy.Publisher("/jackal_velocity_controller/cmd_vel", Twist, queue_size=10)
    rospy.init_node("example_robot_driver", anonymous=True)
    rate = rospy.Rate(10)  # 10hz

    for i in range(100):
        msg = Twist()
        msg.linear.x = 1
        pub.publish(msg)
        rate.sleep()

    print("Done driving")


if __name__ == "__main__":
    try:
        driver()
    except rospy.ROSInterruptException:
        pass
