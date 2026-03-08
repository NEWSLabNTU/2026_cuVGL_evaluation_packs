# Rename zedmx_camera_center to base_link, and store it as a new rosbag
remap_base_frame:
    python scripts/remap_frames.py --source-bag rosbag2_build_square --output-bag rosbag2_build_square_renamed

# End to End cuVSLAM and cuVGL maps creation
create_map_offline:
    ros2 run isaac_mapping_ros create_map_offline.py \
        --sensor_data_bag '../../data/rosbag2_2026_03_04_build_map_renamed' \
        --base_output_folder '../../output' \
        --camera_topic_config 'config/color_camera_topic_config.yaml' \
        --steps_to_run {edex,cuvslam,map_frames,cuvgl}
## Some other arguments of create_map_offline.py
# --steps_to_run {,edex,cuvslam,map_frames,depth,occupancy,cuvgl} [{,edex,cuvslam,map_frames,depth,occupancy,cuvgl} ...]
#                         Specify which steps to run.
# --prebuilt_bow_vocabulary_folder PREBUILT_BOW_VOCABULARY_FOLDER
#                         Folder containing prebuilt BoW vocabulary files.
# --print_mode {none,tail,all}
#                         Determines what is printed to stdout.
# --map_dir MAP_DIR     Directory containing existing map data.
# --image_extension IMAGE_EXTENSION
#                         Determines the image format to save on disk.


#===Do not use! The explanations of the last two arguments are missing===#
# build-map-color:
#     #!/usr/bin/env bash
#     ros2 run isaac_mapping_ros rosbag_to_mapping_data \
#         --sensor_data_bag_file='data/2026-02-05 Ming-Da 3F vslam rosbags/rosbag2_build_winding' \
#         --pose_bag_file='data/2026-02-05 Ming-Da 3F vslam rosbags/rosbag2_build_winding' \
#         --pose_topic_name='/visual_slam/vis/slam_odometry' \
#         --base_link_name='zedxm_camera_center' \
#         --output_folder_path='output/keyframes' \
#         --camera_topic_config='src/mapping/color_camera_topic_config.yaml' \
#         --rectify_images=false \
#         --extract_feature=true \
#         --min_inter_frame_distance=0 \
#         --min_inter_frame_rotation_degrees=0
#         --keypoint_creation_config $(ros2 pkg prefix isaac_mapping_ros)/share/isaac_mapping_ros/configs/keypoint_creation_config.pb.txt \
#         # --keyframe_topic_name <keyframe_topic_name> \
