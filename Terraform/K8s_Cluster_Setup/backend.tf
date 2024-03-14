terraform {
  backend "s3" {
    bucket = "projectbucket-vibish"
    key    = "project-03/k8scluster_server/terrafomr.tfstate"
    region = "ap-south-1"
  }
}
