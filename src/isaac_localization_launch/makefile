# Warning: use this makefile only in a container

SHELL := /bin/bash

# Shared directory paths
MAPS_DIR := ../../output/2026-03-08_14-19-27_rosbag2_2026_03_04_build_map_renamed
DATA_DIR := ../../data
DOCS_DIR := ../../docs

# build the isaac_localization_launch pakage
build:
	colcon build --symlink-install --packages-select isaac_localization_launch
	@echo "To source the workspace, run: source install/setup.bash"

clean:
	rm -rf build install log

# launch cuVGL and cuVSLAM
run:
	@if [ -n "$$DISPLAY" ]; then \
		ros2 launch isaac_localization_launch central_launch.xml \
			vgl_map_dir:=$(MAPS_DIR)/cuvgl_map \
			vslam_map_dir:=$(MAPS_DIR)/cuvslam_map \
			start_vgl:=true \
			start_vslam:=true \
			start_rviz:=true; \
	else \
		ros2 launch isaac_localization_launch central_launch.xml \
			vgl_map_dir:=$(MAPS_DIR)/cuvgl_map \
			vslam_map_dir:=$(MAPS_DIR)/cuvslam_map \
			start_vgl:=true \
			start_vslam:=true \
			start_rviz:=false; \
	fi


# The offical launch file that brings up cuVGL
run_isaac:
	ros2 launch isaac_ros_visual_global_localization isaac_ros_visual_global_localization_node.launch.py \
		vgl_map_dir:=$(MAPS_DIR)/cuvgl_map


# replay rosbag including the topics cuVGL subscribed
replay:
	ros2 bag play $(DATA_DIR)/rosbag2_2026_03_04_build_map \
		--topics $(shell cat $(DOCS_DIR)/replay_color_topics.txt)

record_vgl_result:
	ros2 bag record $(shell cat $(DOCS_DIR)/record_topics.txt)

# trigger_localization:
# 	ros2 topic pub /visual_localization/pose geometry_msgs/msg/PoseWithCovarianceStamped "header:
#   stamp:
#     sec: 1770283983
#     nanosec: 969642000
#   frame_id: map
# pose:
#   pose:
#     position:
#       x: 0.0
#       y: 0.0
#       z: 0.0
#     orientation:
#       x: 0.0
#       y: 0.0
#       z: 0.0
#       w: 1.0
#   covariance:
#   - 0.0
#   - 0.0"

# ros2 service call /visual_slam/set_slam_pose isaac_ros_visual_slam_interfaces/SetSlamPose "
#   pose:
#     position:
#       x: 6.0
#       y: 0.0
#       z: 0.0
#     orientation:
#       x: 1.0
#       y: 0.0
#       z: 0.0
#       w: 0.0"