resource "aws_vpc" "word_press_vpc" {
  cidr_block       = var.main_vpc_cidr
  instance_tenancy = "default"
  tags = {
    Name = "wordpress-vpc"
  }
}

#Internet Gateway
resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.word_press_vpc.id
  tags = {
    Name = "wordpress_igw"
  }
}

#cidr vars 
variable "public_subnet_1_cidr" {}
variable "public_subnet_2_cidr" {}
variable "public_subnet_3_cidr" {}

variable "private_subnet_1_cidr" {}
variable "private_subnet_2_cidr" {}
variable "private_subnet_3_cidr" {}

# Public Subnet
resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.word_press_vpc.id
  cidr_block        = var.public_subnet_1_cidr
  availability_zone = "us-east-1a" # Replace with your desired availability zone
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id            = aws_vpc.word_press_vpc.id
  cidr_block        = var.public_subnet_2_cidr
  availability_zone = "us-east-1b" # Replace with your desired availability zone
}

resource "aws_subnet" "public_subnet_3" {
  vpc_id            = aws_vpc.word_press_vpc.id
  cidr_block        = var.public_subnet_3_cidr
  availability_zone = "us-east-1c" # Replace with your desired availability zone
}


# Private Subnet
resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.word_press_vpc.id
  cidr_block        = var.private_subnet_1_cidr
  availability_zone = "us-east-1d" # Replace with your desired availability zone
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.word_press_vpc.id
  cidr_block        = var.private_subnet_2_cidr
  availability_zone = "us-east-1e" # Replace with your desired availability zone
}

resource "aws_subnet" "private_subnet_3" {
  vpc_id            = aws_vpc.word_press_vpc.id
  cidr_block        = var.private_subnet_3_cidr
  availability_zone = "us-east-1f" # Replace with your desired availability zone
}

resource "aws_db_subnet_group" "private_db_subnet_group" {
  name       = "private-db-subnet-group"
  subnet_ids = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id, aws_subnet.private_subnet_3.id]
}
resource "aws_route_table" "PublicRT" {
  vpc_id = aws_vpc.word_press_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }
}

resource "aws_nat_gateway" "NATgw" {
  allocation_id = aws_eip.nateIP.id
  subnet_id     = aws_subnet.public_subnet_1.id
}

resource "aws_route_table" "PrivateRT" {
  vpc_id = aws_vpc.word_press_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.NATgw.id
  }
}


resource "aws_route_table_association" "PublicRTassociation" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.PublicRT.id
}

resource "aws_route_table_association" "PrivateRTassociation" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.PrivateRT.id
}

resource "aws_eip" "nateIP" {
  vpc = true
}
