#!/bin/bash 
# Check if correct number of arguments are provided 
if [ "$#" -ne 3 ]; then 
  echo "Usage: $0 <volume_name> <total_storage_size_in_gb> <client_name>" 
  exit 1 
fi 
 
# Assigning CLI arguments to variables 
VOLUME_NAME=$1 
TOTAL_SIZE_GB=$2 
CLIENT_NAME=$3 
 
# Calculate size for metadata pool (assuming 5% of total size) 
METADATA_SIZE_GB=$(echo "$TOTAL_SIZE_GB * 0.05" | bc) 
METADATA_SIZE_BYTES=$(echo "$METADATA_SIZE_GB * 1024 * 1024 * 1024" | bc) 
 
# Calculate size for data pool (remaining 95% of total size) 
DATA_SIZE_GB=$(echo "$TOTAL_SIZE_GB * 0.95" | bc) 
DATA_SIZE_BYTES=$(echo "$DATA_SIZE_GB * 1024 * 1024 * 1024" | bc) 
 
# Create Metadata Pool 
echo "Creating metadata pool '${VOLUME_NAME}_metadata_pool' with size ${METADATA_SIZE_GB} GiB..." 
ceph osd pool create ${VOLUME_NAME}_metadata_pool 128 
ceph osd pool set ${VOLUME_NAME}_metadata_pool pg_autoscale_mode on 
ceph osd pool set ${VOLUME_NAME}_metadata_pool target_size_bytes $METADATA_SIZE_BYTES 
 
# Create Data Pool 
echo "Creating data pool '${VOLUME_NAME}_data_pool' with size ${DATA_SIZE_GB} GiB..." 
ceph osd pool create ${VOLUME_NAME}_data_pool 128 
ceph osd pool set ${VOLUME_NAME}_data_pool pg_autoscale_mode on 
ceph osd pool set ${VOLUME_NAME}_data_pool target_size_bytes $DATA_SIZE_BYTES 
 
# Enable bulk mode for the data pool to suppress warnings 
ceph osd pool set ${VOLUME_NAME}_data_pool bulk true 
 
# Create CephFS filesystem 
echo "Creating the CephFS filesystem '$VOLUME_NAME'..." 
ceph fs new $VOLUME_NAME ${VOLUME_NAME}_metadata_pool ${VOLUME_NAME}_data_pool 
 
# Create a Ceph client for accessing the filesystem 
echo "Creating client '$CLIENT_NAME'..." 
ceph auth get-or-create client.$CLIENT_NAME mon 'allow r' mgr 'allow rw' mds 'allow rw fsname=$VOLUME_NAME path=/' osd 'allow rw pool=${VOLUME_NAME}_data_pool, allow rw pool=${VOLUME_NAME}_metadata_pool' 
 
# Print out the key for the new client 
ceph auth get-key client.$CLIENT_NAME 
 
#Usage: 
#Run the script like this: 
#./script_name.sh <volume_name> <total_storage_size_in_gb> <client_name>  
#For example: 
#./script_name.sh test1cephfs 150 prashant_k8s 