terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
}


provider "aws" {
  profile = "default"
  region  = "ap-northeast-1"
}



# --------------------------------------------#
# VPC
# --------------------------------------------#

resource "aws_vpc" "vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  tags = {
    "Name" = "${var.tag_prefix}-vpc"
  }
}

# --------------------------------------------#
# Subnet
# --------------------------------------------#
resource "aws_subnet" "pub_sbn" {
  count                   = var.resource_cnt
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index)
  availability_zone       = var.az_list[count.index]
  map_public_ip_on_launch = true
  tags = {
    "Name" = "${var.tag_prefix}-pub-sbn-${var.az_num_list[count.index]}"
  }
}


# --------------------------------------------#
# igw
# --------------------------------------------#
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.tag_prefix}-igw}"
  }
}


# --------------------------------------------#
# Route
# --------------------------------------------#
resource "aws_route_table" "rtb" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.tag_prefix}-rtb}"
  }
}

resource "aws_route" "pub" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.rtb.id
  gateway_id             = aws_internet_gateway.igw.id
}


resource "aws_route_table_association" "pub" {
  count          = var.resource_cnt
  subnet_id      = aws_subnet.pub_sbn[count.index].id
  route_table_id = aws_route_table.rtb.id
}


# --------------------------------------------#
# Security Group
# --------------------------------------------#
resource "aws_security_group" "ec2_sg" {

  name        = "ec2_sg"
  description = "Allow inbound traffic ec2"
  vpc_id      = aws_vpc.vpc.id

  ingress = [
    {
      description      = "allowed inbound ssh acces"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = true
    },

		{
      description      = "allowed inbound http acces"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = true
    }
  ]

  egress = [
    {
      description      = "outbound allowed rule"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = true
    }
  ]

  tags = {
    Name = "${var.tag_prefix}-sg-ec2"
  }
}


# --------------------------------------------#
# EC2 Instance
# --------------------------------------------#
resource "aws_instance" "ec2" {

  # count                       = var.resource_cnt
  count                       = 2
  ami                         = lookup(var.ec2_conf, "ami")
  instance_type               = lookup(var.ec2_conf, "instance_type")
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  subnet_id                   = aws_subnet.pub_sbn[count.index].id
  key_name                    = lookup(var.ec2_conf, "key_pair")
  associate_public_ip_address = "true"

  tags = {
    Name = "${var.tag_prefix}-ec2-pub-${count.index + 1}"
  }
}
