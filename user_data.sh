#!/bin/bash
set -xe

# Log everything to a file for debugging
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

echo "Starting user-data script..."

# Create ECS config directory if it doesn't exist
mkdir -p /etc/ecs

# Write ECS config to ensure instance joins the right cluster
echo "ECS_CLUSTER=${ecs_cluster_name}" > /etc/ecs/ecs.config

echo "ECS config written:"
cat /etc/ecs/ecs.config

# Stop the ECS agent if it's already running
stop ecs || true

# Start the ECS agent
start ecs

# Wait for agent to start
sleep 15

echo "ECS agent started. Checking status..."

# Check if Docker is running
docker ps

# Check ECS agent logs
tail -n 50 /var/log/ecs/ecs-agent.log || echo "ECS agent log not found"

echo "User-data script completed. Instance should be registered with cluster: ${ecs_cluster_name}"
