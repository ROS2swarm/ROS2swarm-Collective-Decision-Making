#!/bin/bash
#    Copyright 2020 Marian Begemann
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.
echo usage: deliver_to_bot 3 for bot 3 &&
# on VM
echo delete old package &&
rm ./../ROS2swarm.tar.gz &&
echo create new package &&
tar -czf ./../ROS2swarm.tar.gz ../ROS2swarm &&
# Bot
echo delete old package on bot and remove old bot code &&
ssh pi@ros2turtle$1.local 'rm ./ROS2swarm.tar.gz && rm -rf ./ROS2swarm' &&
echo copy package to bot &&
scp ./../ROS2swarm.tar.gz  pi@ros2turtle$1.local:~/ &&
echo unpack package &&
ssh pi@ros2turtle$1.local "tar -xzf ./ROS2swarm.tar.gz && echo update robot number && sed -i 's/robot_namespace_NUM_CHANGE_ME/robot_namespace_$1/g' ./ROS2swarm/src/ros2swarm/param/waffle_pi.yaml && echo update robot number in restart script && sed -i 's/NUM_CHANGE_ME/$1/g' ./ROS2swarm/restart_turtle.sh && echo remove old /build /install /log directory && rm -rf ./ROS2swarm/build ./ROS2swarm/install ./ROS2swarm/log && echo source ros2 && source /opt/ros/dashing/setup.bash && echo rebuild && cd ./ROS2swarm && colcon build && source ./install/setup.bash" &&
echo done