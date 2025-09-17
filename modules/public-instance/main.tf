# Security group for public instance
resource "aws_security_group" "public_sg" {
  name        = "${var.vpc_name}-public-sg"
  description = "Allow SSH from anywhere for public instance"
  vpc_id      = var.vpc_id
  
  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name        = "${var.vpc_name}-public-sg"
    Environment = var.environment
  }
}

# Create public EC2 instance
resource "aws_instance" "public" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  subnet_id     = var.public_subnet_id
  
  vpc_security_group_ids = [aws_security_group.public_sg.id]
  key_name               = var.key_name
  
  tags = {
    Name        = "${var.vpc_name}-public-instance"
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
