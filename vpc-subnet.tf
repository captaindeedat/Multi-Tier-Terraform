resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "Terraform VPC"
  }
}

resource "aws_subnet" "web_subnets" {
  count             = 2
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.${count.index}.0/24"
  #availability_zone = var.az1
  availability_zone = var.ava_zones[count.index]
  
  tags = {
    Name   = "Terraform Web"
  }
  
}

resource "aws_subnet" "app_subnets" {
  count             = 2
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.${count.index + 2}.0/24"
  #availability_zone = var.az1
  availability_zone = var.ava_zones[count.index]
  
  tags = {
    Name   = "Terraform App"
  }
  
}

resource "aws_subnet" "db_subnets" {
  count             = 2
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.${count.index + 4}.0/24"
  #availability_zone = var.az2
  availability_zone = var.ava_zones[count.index]
  
  tags = {
    Name   = "Terraform DB"
  }
  
}
