resource "aws_route_table" "public_route_table" {
  
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }
}

resource "aws_route_table" "private_route_table" {
  
  vpc_id = aws_vpc.my_vpc.id
}

resource "aws_route_table_association" "web_subnet_associations" {
  count          = 2
  subnet_id      = aws_subnet.web_subnets[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "app_subnet_associations" {
  count          = 2
  subnet_id      = aws_subnet.app_subnets[count.index].id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "db_subnet_associations" {
  count          = 2
  subnet_id      = aws_subnet.db_subnets[count.index].id
  route_table_id = aws_route_table.private_route_table.id
}
