terraform {
  backend "s3" {
    bucket = "projectbucket-vibish"
    key    = "project-03/jenkins_server/terrafomr.tfstate"
    region = "ap-south-1"
  }
}
