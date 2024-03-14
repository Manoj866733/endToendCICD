#!/bin/bash

# Update package lists and install Java
sudo apt-get update -y
sudo apt install openjdk-17-jre -y

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