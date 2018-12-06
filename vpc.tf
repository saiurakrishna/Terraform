# VPC
resource "aws_vpc" "myapp" {
  cidr_block = "10.0.0.0/16"
  tags {
    Name = "myapp"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "myapp-igw" {
  vpc_id = "${aws_vpc.myapp.id}"
  tags {
    Name = "myapp-igw"
  }
}

# Subnet Public a
resource "aws_subnet" "myapp_public_a" {
  vpc_id = "${aws_vpc.myapp.id}"
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-2a"
  tags {
    Name = "myapp_public_a"
  }
}

# Subnet Public c
resource "aws_subnet" "myapp_public_c" {
  vpc_id = "${aws_vpc.myapp.id}"
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-2c"
  tags {
    Name = "myapp_public_c"
  }
}
# Routes Table
resource "aws_route_table" "myapp-public-rt" {
  vpc_id = "${aws_vpc.myapp.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.myapp-igw.id}"
  }
  tags {
    Name = "myapp-public-rt"
  }
}

# Routes Table Association a
resource "aws_route_table_association" "myapp-rta-1a" {
  subnet_id = "${aws_subnet.myapp_public_a.id}"
  route_table_id = "${aws_route_table.myapp-public-rt.id}"
}

# Routes Table Association c
resource "aws_route_table_association" "myapp-rta-1c" {
  subnet_id = "${aws_subnet.myapp_public_c.id}"
  route_table_id = "${aws_route_table.myapp-public-rt.id}"
}
    

