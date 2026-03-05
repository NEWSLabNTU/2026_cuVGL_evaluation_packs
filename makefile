# Warning: use this makefile only in a container

# build the isaac_localization_launch pakage
build:
	colcon build --symlink-install --packages-select isaac_localization_launch

clean:
	rm -rf build install log

# launch cuVGL and cuVSLAM
launch:
	@if [ -n "$$DISPLAY" ]; then \
		ros2 launch isaac_localization_launch central_launch.xml \
			vgl_map_dir:=end2end_output/2026-02-08_13-39-00_rosbag2_build_winding_renamed/cuvgl_map \
			vslam_map_dir:=end2end_output/2026-02-08_13-39-00_rosbag2_build_winding_renamed/cuvslam_map \
			start_vgl:=true \
			start_vslam:=true \
			start_rviz:=true; \
	else \
		ros2 launch isaac_localization_launch central_launch.xml \
			vgl_map_dir:=end2end_output/2026-02-08_13-39-00_rosbag2_build_winding_renamed/cuvgl_map \
			vslam_map_dir:=end2end_output/2026-02-08_13-39-00_rosbag2_build_winding_renamed/cuvslam_map \
			start_vgl:=true \
			start_vslam:=true \
			start_rviz:=false; \
	fi

# [Deprecated, use central_launch.xml instead] launch cuVGL
run:
	@if [ -n "$$DISPLAY" ]; then \
		ros2 launch isaac_localization_launch vgl_node_launch.xml \
			map_dir:=end2end_output/2026-02-08_13-39-00_rosbag2_build_winding_renamed/cuvgl_map \
			start_rviz:=true; \
	else \
		ros2 launch isaac_localization_launch vgl_node_launch.xml \
			map_dir:=end2end_output/2026-02-08_13-39-00_rosbag2_build_winding_renamed/cuvgl_map \
			start_rviz:=false; \
	fi

# The offical launch file that brings up cuVGL
run_isaac:
	ros2 launch isaac_ros_visual_global_localization isaac_ros_visual_global_localization_node.launch.py \
		vgl_map_dir:=end2end_output/2026-02-08_13-39-00_rosbag2_build_winding_renamed/cuvgl_map

# replay rosbag including the topics cuVGL subscribed
replay:
	ros2 bag play data/rosbag2_val_straight/ \
		--topics $(shell cat docs/replay_topics.txt)

replay_in_sample:
	ros2 bag play data/rosbag2_build_square/ \
		--topics $(shell cat docs/replay_topics.txt)

record_vgl_result:
	ros2 bag record $(shell cat docs/record_topics.txt)

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