# Create VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  
  tags = {
    Name        = var.vpc_name
    Environment = var.environment
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  
  tags = {
    Name        = var.igw_name
    Environment = var.environment
  }
}

# Create public subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_cidr
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true
  
  tags = {
    Name        = "${var.vpc_name}-public-subnet"
    Environment = var.environment
  }
}

# Create second public subnet for NAT Gateway
resource "aws_subnet" "public_2" {
  count = var.enable_nat_gateway ? 1 : 0

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_2_cidr
  availability_zone       = "${var.aws_region}b"
  map_public_ip_on_launch = true
  
  tags = {
    Name        = "${var.vpc_name}-public-subnet-2"
    Environment = var.environment
  }
}

# Create private subnet
resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_cidr
  availability_zone       = "${var.aws_region}c"
  map_public_ip_on_launch = false
  
  tags = {
    Name        = "${var.vpc_name}-private-subnet"
    Environment = var.environment
  }
}

# Create Elastic IP for NAT Gateway
resource "aws_eip" "nat" {
  count = var.enable_nat_gateway ? 1 : 0

  domain = "vpc"
  
  tags = {
    Name        = "${var.vpc_name}-nat-eip"
    Environment = var.environment
  }
}

# Create NAT Gateway
resource "aws_nat_gateway" "main" {
  count = var.enable_nat_gateway ? 1 : 0

  allocation_id = aws_eip.nat[0].id
  subnet_id     = aws_subnet.public_2[0].id
  
  tags = {
    Name        = var.nat_gateway_name
    Environment = var.environment
  }

  depends_on = [aws_internet_gateway.main]
}

# Create route table for public subnet
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  
  tags = {
    Name        = "${var.vpc_name}-public-rt"
    Environment = var.environment
  }
}

# Create route table for private subnet
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  
  # Route for NAT Gateway (outbound internet for private instances)
  dynamic "route" {
    for_each = var.enable_nat_gateway ? [1] : []
    content {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.main[0].id
    }
  }
  
  tags = {
    Name        = "${var.vpc_name}-private-rt"
    Environment = var.environment
  }
}

# Associate public subnet with public route table
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Associate second public subnet with existing public route table
resource "aws_route_table_association" "public_2" {
  count = var.enable_nat_gateway ? 1 : 0

  subnet_id      = aws_subnet.public_2[0].id
  route_table_id = aws_route_table.public.id
}

# Associate private subnet with private route table
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}
