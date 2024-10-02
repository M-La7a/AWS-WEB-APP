# Create Private Route Table for Subnets using NAT
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main_vpc.id
    route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
    Name = "Private Route Table"
  }
}