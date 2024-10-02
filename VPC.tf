# Create VPC
resource "aws_vpc" "main_vpc" {
  cidr_block = "192.168.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "Main VPC"
  }
}

# Create Public Subnet for Jump Server and NAT Gateway
resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "192.168.4.0/24"
  availability_zone = "us-east-1a" # Adjust to your preferred AZ
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet 1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "192.168.5.0/24"
  availability_zone = "us-east-1b" # Adjust to your preferred AZ
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet 2"
  }
}
# Create Private Subnet for EC2 instances (AZ1)
resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "192.168.2.0/24"
  availability_zone = "us-east-1a" # Adjust to your preferred AZ

  tags = {
    Name = "Private Subnet 1"
  }
}

# Create Private Subnet for EC2 instances (AZ2)
resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "192.168.3.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "Private Subnet 2"
  }
}

# Create Private Subnet for MySQL
resource "aws_subnet" "private_subnet_db" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "192.168.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Private Subnet for MySQL"
  }
}
