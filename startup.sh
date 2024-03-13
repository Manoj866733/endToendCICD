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

# Run SonarQube
docker run -d -p 9000:9000 sonarqube:lts-community

# Run Nexus
docker run -d -p 8081:8081 sonatype/nexus3


######################################



