#include <rclcpp/rclcpp.hpp>
#include <sensor_msgs/msg/image.hpp>
#include <cv_bridge/cv_bridge.h>
#include <opencv2/opencv.hpp>
#include <rclcpp/qos.hpp>

class ImageConverterNode : public rclcpp::Node
{
public:
    ImageConverterNode()
    : Node("image_converter_node")
    {
        // Use BEST_EFFORT QoS for image topics to match ZED camera
        auto qos = rclcpp::QoS(10).reliability(RMW_QOS_POLICY_RELIABILITY_BEST_EFFORT);

        // Create subscriptions for left and right color images
        left_sub_ = this->create_subscription<sensor_msgs::msg::Image>(
            "/zedxm/zed_node/left/color/rect/image",
            qos,
            std::bind(&ImageConverterNode::left_callback, this, std::placeholders::_1));

        right_sub_ = this->create_subscription<sensor_msgs::msg::Image>(
            "/zedxm/zed_node/right/color/rect/image",
            qos,
            std::bind(&ImageConverterNode::right_callback, this, std::placeholders::_1));

        // Create publishers for converted grayscale images
        left_pub_ = this->create_publisher<sensor_msgs::msg::Image>(
            "/zedxm/gray_converter/left/image_rect_gray", qos);

        right_pub_ = this->create_publisher<sensor_msgs::msg::Image>(
            "/zedxm/gray_converter/right/image_rect_gray", qos);

        RCLCPP_INFO(this->get_logger(), "Image Converter Node started");
        RCLCPP_INFO(this->get_logger(), "Converting BGRA8 -> MONO8 from ZED camera");
    }

private:
    void left_callback(const sensor_msgs::msg::Image::SharedPtr msg)
    {
        try {
            // Convert ROS Image to OpenCV format (BGRA)
            cv_bridge::CvImagePtr cv_ptr = cv_bridge::toCvCopy(msg, sensor_msgs::image_encodings::BGRA8);

            // Convert BGRA to grayscale (MONO8)
            cv::Mat gray_image;
            cv::cvtColor(cv_ptr->image, gray_image, cv::COLOR_BGRA2GRAY);

            // Convert back to ROS Image message
            sensor_msgs::msg::Image::SharedPtr gray_msg = cv_bridge::CvImage(
                msg->header, sensor_msgs::image_encodings::MONO8, gray_image).toImageMsg();

            // Publish
            left_pub_->publish(*gray_msg);
        } catch (const cv_bridge::Exception& e) {
            RCLCPP_ERROR(this->get_logger(), "Left image conversion error: %s", e.what());
        }
    }

    void right_callback(const sensor_msgs::msg::Image::SharedPtr msg)
    {
        try {
            // Convert ROS Image to OpenCV format (BGRA)
            cv_bridge::CvImagePtr cv_ptr = cv_bridge::toCvCopy(msg, sensor_msgs::image_encodings::BGRA8);

            // Convert BGRA to grayscale (MONO8)
            cv::Mat gray_image;
            cv::cvtColor(cv_ptr->image, gray_image, cv::COLOR_BGRA2GRAY);

            // Convert back to ROS Image message
            sensor_msgs::msg::Image::SharedPtr gray_msg = cv_bridge::CvImage(
                msg->header, sensor_msgs::image_encodings::MONO8, gray_image).toImageMsg();

            // Publish
            right_pub_->publish(*gray_msg);
        } catch (const cv_bridge::Exception& e) {
            RCLCPP_ERROR(this->get_logger(), "Right image conversion error: %s", e.what());
        }
    }

    rclcpp::Subscription<sensor_msgs::msg::Image>::SharedPtr left_sub_;
    rclcpp::Subscription<sensor_msgs::msg::Image>::SharedPtr right_sub_;
    rclcpp::Publisher<sensor_msgs::msg::Image>::SharedPtr left_pub_;
    rclcpp::Publisher<sensor_msgs::msg::Image>::SharedPtr right_pub_;
};

int main(int argc, char * argv[])
{
    rclcpp::init(argc, argv);
    rclcpp::spin(std::make_shared<ImageConverterNode>());
    rclcpp::shutdown();
    return 0;
}