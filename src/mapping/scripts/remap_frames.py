import argparse
import os
import rosbag2_py
from rclpy.serialization import serialize_message, deserialize_message
from rosidl_runtime_py.utilities import get_message

def parse_arguments():
    parser = argparse.ArgumentParser(description="Remap frame_ids in a ROS 2 bag file using named parameters.")
    
    # Required parameters (using flags)
    parser.add_argument("--source-bag", required=True, 
                        help="Name of the source bag folder (Required)")
    parser.add_argument("--output-bag", required=True, 
                        help="Name of the output bag folder (Required)")

    return parser.parse_args()

def get_rosbag_options(path, storage_id='sqlite3'):
    return rosbag2_py.StorageOptions(uri=path, storage_id=storage_id), \
           rosbag2_py.ConverterOptions(input_serialization_format='cdr', output_serialization_format='cdr')


def remap_bag(input_path, output_path, frame_mapping):
    reader = rosbag2_py.SequentialReader()
    reader.open(*get_rosbag_options(input_path))
    
    writer = rosbag2_py.SequentialWriter()
    writer.open(*get_rosbag_options(output_path))

    # Build mapping of topics to types
    topic_types = {topic.name: topic.type for topic in reader.get_all_topics_and_types()}
    for topic in reader.get_all_topics_and_types():
        writer.create_topic(topic)

    while reader.has_next():
        (topic, data, t) = reader.read_next()
        msg_type = get_message(topic_types[topic])
        msg = deserialize_message(data, msg_type)

        # 1. Handle standard Header
        if hasattr(msg, 'header') and hasattr(msg.header, 'frame_id'):
            if msg.header.frame_id in frame_mapping:
                msg.header.frame_id = frame_mapping[msg.header.frame_id]
        
        # 2. Handle child_frame_id
        if hasattr(msg, 'child_frame_id'):
            if msg.child_frame_id in frame_mapping:
                msg.child_frame_id = frame_mapping[msg.child_frame_id]

        # 3. Handle /tf and /tf_static
        if topic in ["/tf", "/tf_static"]:
            for transform in msg.transforms:
                if transform.header.frame_id in frame_mapping:
                    transform.header.frame_id = frame_mapping[transform.header.frame_id]
                if transform.child_frame_id in frame_mapping:
                    transform.child_frame_id = frame_mapping[transform.child_frame_id]

        writer.write(topic, serialize_message(msg), t)


def main():
    args = parse_arguments()

    print(f"Input path:  {args.source_bag}")
    print(f"Output path: {args.output_bag}")

    # Set frame mapping: {'old_name': 'new_name'}
    frame_mapping = {'zedxm_camera_center': 'base_link'}

    if not os.path.exists(args.source_bag):
        print(f"Error: Source bag not found at {args.source_bag}")
        return

    remap_bag(args.source_bag, args.output_bag, frame_mapping)
    print("Processing complete.")


if __name__ == "__main__":
    main()