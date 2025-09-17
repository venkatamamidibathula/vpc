# Security group for private instance
resource "aws_security_group" "private_sg" {
  name        = "${var.vpc_name}-private-sg"
  description = "Allow SSH from within VPC and outbound internet via NAT"
  vpc_id      = var.vpc_id
  
  ingress {
    description = "SSH from within VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }
  
  # Allow all outbound traffic (will go through NAT Gateway)
  egress {
    description = "Outbound internet access via NAT Gateway"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.enable_nat_gateway ? ["0.0.0.0/0"] : [var.vpc_cidr]
  }
  
  tags = {
    Name        = "${var.vpc_name}-private-sg"
    Environment = var.environment
  }
}

# Create private EC2 instance
resource "aws_instance" "private" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  subnet_id     = var.private_subnet_id
  
  vpc_security_group_ids = [aws_security_group.private_sg.id]
  key_name               = var.key_name
  
  associate_public_ip_address = false
  
  tags = {
    Name        = "${var.vpc_name}-private-instance"
    Environment = var.environment
  }
}

# Get the latest Amazon Linux AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
