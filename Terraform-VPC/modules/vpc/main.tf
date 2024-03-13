# VPC
resource "aws_vpc" "my_vpc" {
    cidr_block = var.vpc_cidr
    instance_tenancy = "default"

    tags = {
      "Name" = "my_vpc"
    }
}

# 2 Public Subnets
resource "aws_subnet" "pub_subnets" {
  count = length(var.pub_subnet_cidr)
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = var.pub_subnet_cidr[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  
  tags = {
    Name = var.pub_subnet_names[count.index]
  }
}
# 2 Private Subnets
resource "aws_subnet" "pri_subnets" {
  count = length(var.pri_subnet_cidr)
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = var.pri_subnet_cidr[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  
  tags = {
    Name = var.pri_subnet_names[count.index]
  }
}



# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "MyInternetGateway"
  }
}
# Elastic-IP (eip) for NAT
resource "aws_eip" "nat_eip" {
  depends_on = [aws_internet_gateway.igw]
}
# NAT
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = element(aws_subnet.pub_subnets.*.id, 0)

  tags = {
    Name        = "nat"
  }
}

# Routing tables to route traffic for Public Subnet
resource "aws_route_table" "rt_pub" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name        = "rt-pub"
  }
}
# Routing tables to route traffic for Private Subnet
resource "aws_route_table" "rt_pri" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name        = "rt-pri"
  }
}
# Route for Internet Gateway
resource "aws_route" "public_internet_gateway_route" {
  route_table_id         = aws_route_table.rt_pub.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# Route for NAT
resource "aws_route" "private_nat_gateway_route" {
  route_table_id         = aws_route_table.rt_pri.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

# Public Route Table Association 
resource "aws_route_table_association" "rta-pub" {
  count = length(var.pub_subnet_cidr)
  subnet_id      = aws_subnet.pub_subnets[count.index].id
  route_table_id = aws_route_table.rt_pub.id
}
# Private Route Table Association 
resource "aws_route_table_association" "rta-pri" {
  count = length(var.pri_subnet_cidr)
  subnet_id      = aws_subnet.pri_subnets[count.index].id
  route_table_id = aws_route_table.rt_pri.id
}