#!/bin/bash

# Check if the required number of arguments are passed
if [ "$#" -ne 9 ]; then
    echo "Usage: $0 <CLUSTER_ID> <IP_CEPH_NODE_1> <IP_CEPH_NODE_2> <IP_CEPH_NODE_3> <REPLICAS> <CLIENT_NAME> <CLIENT_KEY> <FS_NAME> <POOL_NAME>"
    exit 1
fi

# Assign CLI arguments to variables
CLUSTER_ID=$1
IP_CEPH_NODE_1=$2
IP_CEPH_NODE_2=$3
IP_CEPH_NODE_3=$4
REPLICAS=$5
CLIENT_NAME=$6
CLIENT_KEY=$7
FS_NAME=$8
POOL_NAME=$9

# Export the variables so envsubst can use them
export CLUSTER_ID IP_CEPH_NODE_1 IP_CEPH_NODE_2 IP_CEPH_NODE_3 REPLICAS CLIENT_NAME CLIENT_KEY FS_NAME POOL_NAME

# Template file path (assuming it's named 'template.yaml')
TEMPLATE_FILE="template.yaml"

# Output file path
OUTPUT_FILE="output.yaml"

# Use envsubst to substitute environment variables in the template and create a new YAML file
envsubst < "$TEMPLATE_FILE" > "$OUTPUT_FILE"

echo "Generated $OUTPUT_FILE with substituted values."
