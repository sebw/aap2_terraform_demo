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
  region = "eu-central-1"
}

resource "aws_vpc" "main_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "main-vpc"
  }
}

resource "aws_security_group" "voxxed_sg" {
  name        = "voxxed-sg"
  description = "Allow SSH and HTTP"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Consider replacing with your IP for security
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "All traffic out"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "voxxed-sg"
  }
}


resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-central-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "main-igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_instance" "centos" {
  ami           = "ami-00513967e6b47e386"
  instance_type = "t3.medium"
  subnet_id                   = aws_subnet.public_subnet.id
  associate_public_ip_address = true
  key_name = "voxxed_key"
  vpc_security_group_ids = [aws_security_group.voxxed_sg.id]
  tags = {
    Name = "CentOS Linux"
  }
}

resource "aws_instance" "amazon" {
  ami           = "ami-00a44bd8918c7ee43"
  instance_type = "t3.medium"
  subnet_id                   = aws_subnet.public_subnet.id
  associate_public_ip_address = true
  key_name = "voxxed_key"
  vpc_security_group_ids = [aws_security_group.voxxed_sg.id]
  tags = {
    Name = "Amazon Linux"
  }
}
