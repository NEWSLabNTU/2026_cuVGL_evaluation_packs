# install just
# curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | sudo bash -s -- --to /usr/local/bin

# install tmux
# sudo apt-get update
# sudo apt-get install -y tmux
# echo 'set -g mouse on' >> ~/.tmux.conf
# tmux kill-server
# tmux

default:
	@echo "List of available commands:"
	@just --list

# Enter the dev container
docker:
    #!/usr/bin/env bash
    src/isaac_ros_common/scripts/run_dev.sh

# Download the rosbag data for map creation and tests
download-data:
    #!/usr/bin/env bash
    cd ${ISAAC_ROS_WS}/data
    gdown --folder https://drive.google.com/drive/folders/1_RbSY8mSOGU8WCVI-U89mHy5ObT5JCu_?usp=drive_link

# Download the Isaac ROS Dev Env docker files
set_up_development_environment:
    #!/usr/bin/env bash
    if [ -z "${ISAAC_ROS_WS}" ] || [ ! -d "${ISAAC_ROS_WS}" ]; then
        echo "Error: ISAAC_ROS_WS is not set or the directory does not exist."
        echo "Please ensure ISAAC_ROS_WS is set in your ~/.bashrc file."
        echo "Example: export ISAAC_ROS_WS=/path/to/your/workspace"
        exit 1
    fi

    cd ${ISAAC_ROS_WS}/src

    # Check if the directory already exists
    if [ ! -d "isaac_ros_common" ]; then
        echo "Cloning isaac_ros_common..."
        git clone -b release-3.2 https://github.com/NVIDIA-ISAAC-ROS/isaac_ros_common.git isaac_ros_common
    else
        echo "isaac_ros_common already exists. Skipping clone."
    fi