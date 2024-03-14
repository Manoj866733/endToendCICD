variable "cidr" {
  type        = string
  description = "VPC-CIDR-JenkinsServer VPC"
}

variable "public_subnets" {
  type        = list(string)
  description = "Public Subnet for JenkinsServer VPC"
}


variable "instance_type" {
  type        = string
  description = "Type Of instance for this activity"
}