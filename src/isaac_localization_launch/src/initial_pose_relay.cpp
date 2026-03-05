#include "rclcpp/rclcpp.hpp"
#include "geometry_msgs/msg/pose_with_covariance_stamped.hpp"

class InitialPoseRelayNode: public rclcpp::Node
{
public:
    InitialPoseRelayNode()
    :   Node("visual_pose_initializer_bridge")
    {
        // subscribe to cuVGL

        // publish to cuVSLAM
    }

private:
    rclcpp::Subscription<geometry_msgs::msg::PoseWithCovarianceStamped>::SharedPtr vgl_subsciption;
    rclcpp::Publisher<geometry_msgs::msg::PoseWithCovarianceStamped>::SharedPtr vgl_subsciption;
}

int main(int argc, char ** argv)
{
  rclcpp::init(argc, argv);
  rclcpp::spin(std::make_shared<InitialPoseRelayNode>());
  rclcpp::shutdown();
  return 0;
}