#!/bin/bash

# Source the ROS 2 setup file
source /opt/ros/humble/setup.bash

# Define the path to the ESS engine to check if it has already been built
ESS_ENGINE="/workspaces/isaac_ros-dev/isaac_ros_assets/models/dnn_stereo_disparity/dnn_stereo_disparity_v4.1.0_onnx/ess.engine"

# Only run the installation if the engine doesn't exist
if [ ! -f "$ESS_ENGINE" ]; then
    echo "========================================================"
    echo "First time setup: Compiling Isaac ROS models..."
    echo "This requires GPU access and will take a few minutes."
    echo "========================================================"
    
    yes | ros2 run isaac_ros_ess_models_install install_ess_models.sh --eula
    yes | ros2 run isaac_ros_peoplesemseg_models_install install_peoplesemseg_vanilla.sh --eula
    yes | ros2 run isaac_ros_peoplesemseg_models_install install_peoplesemseg_shuffleseg.sh --eula
    
    echo "Model compilation complete!"
else
    echo "Isaac ROS TensorRT models are already compiled. Ready to go!"
fi
