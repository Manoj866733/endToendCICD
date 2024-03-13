#!/bin/bash

# Update package lists and install Java
sudo yum update -y
sudo yum install java-17-openjdk-devel -y

# Install Jenkins
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
sudo yum update -y
sudo yum install jenkins -y
sudo systemctl start jenkins
sudo systemctl enable jenkins

# Install Trivy for Vulnerability Scanning
sudo yum install wget -y
sudo wget -O /etc/yum.repos.d/trivy.repo https://aquasecurity.github.io/trivy-repo/rpm/trivy.repo
sudo rpm --import https://aquasecurity.github.io/trivy-repo/rpm/signing-key.asc
sudo yum update -y
sudo yum install trivy -y

# Install Docker
sudo yum install docker -y
sudo systemctl start docker
sudo systemctl enable docker

# Run SonarQube
sudo docker run -d -p 9000:9000 sonarqube:lts-community

# Run Nexus
sudo docker run -d -p 8081:8081 sonatype/nexus3
