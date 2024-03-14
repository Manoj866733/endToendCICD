#!/bin/bash

# Disable swap
sudo swapoff -a

# Set hostname
sudo hostnamectl set-hostname master

# Disable SELinux (temporary)
sudo setenforce 0

# Update package lists
sudo yum update -y

# Install containerd
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y containerd.io
sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml
sudo systemctl restart containerd

# Install Kubernetes components
sudo yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
sudo systemctl enable kubelet
sudo systemctl start kubelet

sleep 30

# Initialize Kubernetes cluster (Run this command manually)
sudo kubeadm init --pod-network-cidr=10.244.0.0/16

sleep 30

# Setup kubeconfig for the current user
KUBE_CONFIG="$HOME/.kube/config"
if [ ! -f "$KUBE_CONFIG" ]; then
    sudo mkdir -p $HOME/.kube
    sudo cp -i /etc/kubernetes/admin.conf $KUBE_CONFIG
    sudo chown $(id -u):$(id -g) $KUBE_CONFIG
fi

# Add environment variables to profile (if necessary)
echo "export KUBECONFIG=$HOME/.kube/config" >> $HOME/.bashrc
source $HOME/.bashrc

# Install Weave Net
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"

# Wait for a while for services to start
sleep 30

# Verify installation
kubectl get nodes
kubectl get pods --all-namespaces
