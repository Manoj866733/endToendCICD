terraform {
  backend "s3" {
    bucket = "projectbucket-vibish"
    key    = "project-03/Monitor/terrafomr.tfstate"
    region = "ap-south-1"
  }
}
