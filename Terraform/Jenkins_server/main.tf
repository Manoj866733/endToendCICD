#Creating VPC For Jenkins Server

module "vpc" {
  source                  = "terraform-aws-modules/vpc/aws"
  name                    = "VPC-Project03"
  cidr                    = var.cidr
  azs                     = data.aws_availability_zones.azs.names
  public_subnets          = var.public_subnets
  map_public_ip_on_launch = true
  enable_dns_hostnames    = true

  tags = {
    name        = "VPC-Project03"
    Terraform   = "true"
    Environment = "dev"
  }

  public_subnet_tags = {
    Name = "Public-Subnet-Project03"
  }

}

#Creating SG Group for Jenkins Server

module "vote_service_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "sg-Project03"
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
    name = "sg-Project03"
  }

}

#Creating EC2 For Jenkins Server

module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = "Jenkins_Server-Project03"

  instance_type               = var.instance_type
  key_name                    = "Basic_US_EAST_1"
  monitoring                  = true
  vpc_security_group_ids      = [module.vote_service_sg.security_group_id]
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  user_data                   = file("jenkins-server-setup.sh")
  availability_zone           = data.aws_availability_zones.azs.names[0]

  tags = {
    name        = "Jenkins_Server-Project03"
    Terraform   = "true"
    Environment = "dev"
  }
}