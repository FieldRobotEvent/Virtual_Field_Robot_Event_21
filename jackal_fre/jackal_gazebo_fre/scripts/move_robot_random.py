#!/usr/bin/env python

# from https://answers.gazebosim.org//question/22125/how-to-set-a-models-position-using-gazeboset_model_state-service-in-python/
import rospy
from gazebo_msgs.msg import ModelState 
from gazebo_msgs.srv import SetModelState
import random
import tf
import time


def main(x_range=0.2, y_range=0.2, yaw_range=0.2):
    rospy.init_node('set_pose')
    state_msg = ModelState()
    state_msg.model_name = 'jackal'
    state_msg.pose.position.x = random.random() * x_range * 2 - x_range
    state_msg.pose.position.y = random.random() * y_range * 2 - x_range
    state_msg.pose.position.z = 0.1

    yaw = random.random() * yaw_range * 2 - yaw_range
    quaternion = tf.transformations.quaternion_from_euler(0, 0, yaw)
    state_msg.pose.orientation.x = quaternion[0]
    state_msg.pose.orientation.y = quaternion[1]
    state_msg.pose.orientation.z = quaternion[2]
    state_msg.pose.orientation.w = quaternion[3]

    rospy.wait_for_service('/gazebo/set_model_state')
    set_state = rospy.ServiceProxy('/gazebo/set_model_state', SetModelState)

    for i in range(10):    
        resp = set_state( state_msg )
        if resp.success:
            print('model location randomized')
            break
        else:
            print('model not found yet, will try again in 1 second')
	    time.sleep(1)


if __name__ == '__main__':
    try:
        main()
    except rospy.ROSInterruptException:
        pass
