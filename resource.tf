# creating a custom vpc
resource "aws_vpc" "lienge" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
    tags = {
    Name = "lienge"
  }
}

# create internet gateway
resource "aws_internet_gateway" "my_igw" {  
  vpc_id = aws_vpc.lienge.id
    tags = {
    Name = "my_igw"
  }
}

# create public subnet
resource "aws_subnet" "public_sb" {  
  vpc_id     = aws_vpc.lienge.id
  cidr_block = "10.0.34.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
    tags = {
    Name = "public_sb"
  }
}

#create private subnet
resource "aws_subnet" "private_sb" {  
  vpc_id     = aws_vpc.lienge.id
  cidr_block = "10.0.4.0/24"
  availability_zone       = "us-east-1b" 
  map_public_ip_on_launch = false
    tags = {
    Name = "private_sb"
  }
}

#create public route table
resource "aws_route_table" "pubrt" {
  vpc_id = aws_vpc.lienge.id

  route {
    cidr_block = "0.0.0.0/0" 
    gateway_id = aws_internet_gateway.my_igw.id
  }
    tags = {
    Name = "pubrt"
  }
}

# create private route table 
resource "aws_route_table" "prirt" {
  vpc_id = aws_vpc.lienge.id
    tags = {
    Name = "prirt"
  }
}

# attach public route table
resource "aws_route_table_association" "pubas" {
  subnet_id      = aws_subnet.public_sb.id
  route_table_id = aws_route_table.pubrt.id
  
}

# attach private route table
resource "aws_route_table_association" "privas" {
  subnet_id      = aws_subnet.private_sb.id
  route_table_id = aws_route_table.prirt.id
}
