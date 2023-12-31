resource "aws_vpc" "demo" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "DemoVPC"
  }
}

resource "aws_subnet" "PublicSubnetA" {
  vpc_id            = aws_vpc.demo.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "ap-southeast-2a"

  map_public_ip_on_launch = true
  tags = {
    Name = "PublicSubnetA"
  }
}

resource "aws_subnet" "PublicSubnetB" {
  vpc_id            = aws_vpc.demo.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-southeast-2b"

  map_public_ip_on_launch = true
  tags = {
    Name = "PublicSubnetB"
  }
}

resource "aws_subnet" "PrivateSubnetA" {
  vpc_id            = aws_vpc.demo.id
  cidr_block        = "10.0.16.0/20"
  availability_zone = "ap-southeast-2a"

  map_public_ip_on_launch = false # default
  tags = {
    Name = "PrivateSubnetA"
  }
}

resource "aws_subnet" "PrivateSubnetB" {
  vpc_id            = aws_vpc.demo.id
  cidr_block        = "10.0.32.0/20"
  availability_zone = "ap-southeast-2b"

  map_public_ip_on_launch = false # default
  tags = {
    Name = "PrivateSubnetB"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.demo.id

  tags = {
    Name = "DemoIGW"
  }
}

resource "aws_route_table" "PublicRouteTable" {
  vpc_id = aws_vpc.demo.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "PublicRouteTable"
  }
}

resource "aws_route_table_association" "addPublicA" {
  subnet_id      = aws_subnet.PublicSubnetA.id
  route_table_id = aws_route_table.PublicRouteTable.id
}

resource "aws_route_table_association" "addPublicB" {
  subnet_id      = aws_subnet.PublicSubnetB.id
  route_table_id = aws_route_table.PublicRouteTable.id
}

resource "aws_route_table" "PrivateRouteTable" {
  vpc_id = aws_vpc.demo.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.example.id
  }

  tags = {
    Name = "PrivateRouteTable"
  }
}

resource "aws_route_table_association" "addPrivateA" {
  subnet_id      = aws_subnet.PrivateSubnetA.id
  route_table_id = aws_route_table.PrivateRouteTable.id
}

resource "aws_route_table_association" "addPrivateB" {
  subnet_id      = aws_subnet.PrivateSubnetB.id
  route_table_id = aws_route_table.PrivateRouteTable.id
}

resource "aws_eip" "forNatGateway" {
}


resource "aws_nat_gateway" "example" {
  allocation_id = aws_eip.forNatGateway.id
  subnet_id     = aws_subnet.PublicSubnetA.id

  tags = {
    Name = "gw NAT"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  # depends_on = [aws_internet_gateway.example]
}
