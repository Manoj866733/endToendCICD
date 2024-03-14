#!/bin/bash

# Update package lists and install Java
sudo apt-get update -y
sudo apt install openjdk-17-jre -y

# Install Jenkins
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install jenkins -y
sudo service jenkins start

# Install Trivy for Vulnerability Scanning
sudo apt-get update -y
sudo apt-get install wget apt-transport-https gnupg lsb-release -y
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
echo deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main | sudo tee -a /etc/apt/sources.list.d/trivy.list
sudo apt-get update -y
sudo apt-get install trivy -y

# Install Docker
sudo apt-get update -y
sudo apt-get install docker.io -y
sudo chmod 666 /var/run/docker.sock
sudo service docker start
sudo systemctl enable docker

# Start Docker Service and Run Containers
sudo service docker start
sudo systemctl enable docker


#installing kubectl

curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
sudo chmod +x ./kubectl
sudo mv ./kubectl /usr/bin/kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
kubectl version --client

echo "Success All installation done on Jenkins Server"

###Completed




