resource "aws_vpc" "main_tf_vpc" {
  cidr_block           = var.my-vpc-cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  }


#public subnets
resource "aws_subnet" "public_subnet" {
    count = length(var.public_subnet)
    vpc_id = aws_vpc.main_tf_vpc.id
    cidr_block = var.public_subnet[count.index]
  
}


# public route table 
resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.main_tf_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-rt-tf"
  }
}


#public sub 1 rtb association
resource "aws_route_table_association" "public-sub-1-assoc" {
  count =  length(var.public_subnet)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public-route-table.id
}

#private subnets
resource "aws_subnet" "private_subnet" {
  count = length(var.private_subnet)
  vpc_id = aws_vpc.main_tf_vpc.id
  cidr_block = var.private_subnet[count.index]
}



#private sub 1 rtb association
resource "aws_route_table_association" "private-sub-2-assoc" {
  count = length(var.private_subnet)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private-route-table.id
}

# private route table 
resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.main_tf_vpc.id

  #    route {
  #     cidr_block = "0.0.0.0/0"
  #     nat_gateway_id = aws_nat_gateway.ngw.id
    }



#private sub 1 rtb association
resource "aws_route_table_association" "private-sub-1-assoc" {
  count = length(var.private_subnet)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private-route-table.id

}

#internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_tf_vpc.id

  tags = {
    Name = "igw-tf"
  }
}


#nat gateway
resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.eip-tf.id
  subnet_id     = aws_subnet.public_subnet[0].id

  tags = {
    Name = "ngw-tf"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}


resource "aws_eip" "eip-tf" {
#   domain = "vpc"
  tags = {
    Name = "dp-eip-tf"
  }
}



#route association for nat gateway and private route table
resource "aws_route" "nat-assoc-wf-priv-rtb" {
  route_table_id         = aws_route_table.private-route-table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.ngw.id
}
