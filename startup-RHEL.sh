#!/bin/bash

# Update package lists and install Java
sudo yum update -y
sudo yum install java-17-openjdk-devel -y

# Install Jenkins
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum update -y
sudo yum install jenkins -y
sudo systemctl start jenkins
sudo systemctl enable jenkins

# Install Trivy for Vulnerability Scanning
rpm -ivh https://github.com/aquasecurity/trivy/releases/download/v0.18.3/trivy_0.18.3_Linux-64bit.rpm
export PATH="/usr/local/bin/trivy:$PATH"
source ~/.bashrc  # or ~/.bash_profile, ~/.zshrc, depending on your shell
source ~/.bash_profile

# Install Docker
sudo yum install docker -y
sudo systemctl start docker
sudo systemctl enable docker

# Run SonarQube
sudo docker run -d -p 9000:9000 sonarqube:lts-community

# Run Nexus
sudo docker run -d -p 8081:8081 sonatype/nexus3
