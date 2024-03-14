#Creating VPC For Jenkins Server

module "vpc" {
  source                  = "terraform-aws-modules/vpc/aws"
  name                    = "VPC-Jenkins-Project03"
  cidr                    = var.cidr
  azs                     = data.aws_availability_zones.azs.names
  public_subnets          = var.public_subnets
  map_public_ip_on_launch = true
  enable_dns_hostnames    = true

  tags = {
    Name        = "VPC-Jenkins-Project03"
    Terraform   = "true"
    Environment = "dev"
  }

  public_subnet_tags = {
    Name = "Public-Jenkins-Project03"
  }

}

#Creating SG Group for Jenkins Server

module "vote_service_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "Jenkins-Project03-sg"
  description = "sg for Project03"
  vpc_id      = module.vpc.vpc_id
  ingress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  tags = {
    Name = "Jenkins-Project03-sg"
  }

}

#Creating EC2 For Jenkins Server

module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = "Jenkins_Server-Project03"
  ami = var.ami_id
  instance_type               = var.instance_type
  key_name                    = "Basic_US_EAST_1"
  monitoring                  = true
  vpc_security_group_ids      = [module.vote_service_sg.security_group_id]
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  user_data                   = file("jenkins-server-setup.sh")
  availability_zone           = data.aws_availability_zones.azs.names[0]
  root_block_device = [
    {
      volume_type = "gp2"
      volume_size = 12
    },
  ]

  tags = {
    Name        = "Jenkins_Server-Project03"
    Terraform   = "true"
    Environment = "dev"
  }
}

output "Jenkins_Access" {
  description = "Access Jenkins Server with below URL"
  value = "http://${module.ec2_instance.public_ip}:8080"
}

output "instance_public_ip" {
  description = "Public IP address of the Jenkins server"
  value       = module.ec2_instance.public_ip
}