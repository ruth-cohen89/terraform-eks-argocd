resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/16"

   tags = {
    Environment = var.env
  }
}

data "aws_availability_zones" "available" {}
resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.this.id
  cidr_block              = "10.0.${count.index}.0/24"
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name                       = "public-subnet-${count.index + 1}"
    # "kubernetes.io/role/elb"   = "1"  # Tag for external LoadBalancer
    "subnet_type"              = "public"
  }
}

resource "aws_subnet" "private" {
  count                   = 2
  vpc_id                  = aws_vpc.this.id
  cidr_block              = "10.0.${count.index + 2}.0/24"
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = false
  tags = {
    Name                             = "private-subnet-${count.index + 1}"
    # "kubernetes.io/role/internal-elb" = "1"  # Tag for internal LoadBalancer
    "subnet_type"                     = "private"
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
}

# Associate Public Route Table with Public Subnets
resource "aws_route_table_association" "public" {
  count          = 2
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}


resource "aws_eip" "nat" {}

resource "aws_nat_gateway" "this" {
  subnet_id     = aws_subnet.public[0].id
  allocation_id = aws_eip.nat.id  # Reference the EIP for the NAT Gateway
  depends_on    = [aws_eip.nat] 
}

# Private Route Table for Private Subnets
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this.id
  }
}

# Associate Private Route Table with Private Subnets
resource "aws_route_table_association" "private" {
  count          = 2
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
