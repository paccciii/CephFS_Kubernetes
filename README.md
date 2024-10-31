Here, I am going to help you out with configuring Ceph CSI plugin with the Kubernetes cluster and use CephFS for storage availability. 

# CephFS with Kubernetes

This repository provides a complete guide for configuring CephFS as a shared file system in a Kubernetes cluster. By leveraging the Ceph CSI plugin, you can set up reliable, scalable storage suitable for applications needing persistent, shared storage across pods.

## Overview

CephFS (Ceph File System) is a POSIX-compliant, scalable storage solution within Ceph. Using CephFS in Kubernetes enables you to provide dynamic, distributed storage to your containerized applications. CephFS is particularly useful for applications needing high availability, durability, and seamless scaling.

## Key Features

- **Dynamic Storage Provisioning**: Allows Kubernetes to automatically provision CephFS volumes.
- **Persistent Storage for Stateful Applications**: Supports stateful workloads requiring data persistence.
- **High Scalability**: Scales with Ceph’s underlying distributed file system, providing robust data redundancy and load balancing.

## Prerequisites

Ensure the following before beginning:

- A **Kubernetes Cluster**: A functioning cluster is required to deploy the CephFS CSI plugin and manifests.
- **Ceph Cluster Access**: Requires access to a Ceph cluster, typically via an admin user or similar privileges.
- **CLI Tools Installed**: Install `kubectl` for managing Kubernetes resources and `ceph` for interacting with the Ceph cluster.

## Files and Structure

- **`ceph_volume_pool_client_creation.sh`**: This script sets up a Ceph pool and client for use in Kubernetes.
- **`cephfs_all_yamlfiles.yml`**: Contains Kubernetes manifest files that define storage classes, persistent volume claims (PVCs), and other configurations necessary for CephFS in Kubernetes.
- **`env_substitute.sh`**: A helper script to replace environment variables in the configuration files, simplifying setup based on your specific environment.

## Installation and Setup

### Step 1: Set Up Ceph Resources
Run the `ceph_volume_pool_client_creation.sh` script on the Ceph cluster to create a dedicated pool and client for Kubernetes. This script will:

- Create a Ceph pool.
- Set up a client with the necessary permissions to access the pool.

### Step 2: Edit the Environment Variables
Modify `env_substitute.sh` to align with your environment’s specifics, such as the Ceph monitor IP, pool name, and client credentials.

### Step 3: Apply the Kubernetes Configuration
After setting up the Ceph resources and adjusting environment variables, apply the Kubernetes manifests:

```bash
source env_substitute.sh
kubectl apply -f cephfs_all_yamlfiles.yml
```

This will deploy storage classes, persistent volumes, and persistent volume claims. Pods can then access storage provisioned via CephFS.

## Usage

Once the setup is complete, CephFS volumes are available for use in Kubernetes applications. You can create PersistentVolumeClaims (PVCs) in your deployment manifests to request storage from CephFS.

Example:

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: example-pvc
spec:
  storageClassName: cephfs
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 1Gi
```

## Troubleshooting

Common issues may include connectivity with the Ceph cluster, permission errors, or misconfigured environment variables. Refer to the logs from the Ceph CSI plugin for detailed diagnostics.

## License

This project is open-source under the MIT License.
