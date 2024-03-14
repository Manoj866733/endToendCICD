terraform {
  backend "s3" {
    bucket = "projectbucket-vibish"
    key    = "project-03/NexusSonar/terrafomr.tfstate"
    region = "ap-south-1"
  }
}
