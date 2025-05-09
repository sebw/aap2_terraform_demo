terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.84.0"
    }
  }

  backend "s3" {}
}

provider "aws" {
  region = "eu-north-1"
}

# Fetch the default VPC
data "aws_vpc" "default" {
  default = true
}

resource "aws_instance" "tf-demo-aws-ec2-instance-1" {
  ami           = "ami-0decbb1739c22d50c"
  instance_type = "t3.micro"
  tags = {
    Name = "tf-demo-aws-ec2-instance-1"
  }

}
