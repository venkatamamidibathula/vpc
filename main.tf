terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Generate key pair
resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "this" {
  key_name   = var.key_name
  public_key = tls_private_key.this.public_key_openssh
  tags = {
    Name = var.key_name
  }
}

resource "local_file" "private_key" {
  content         = tls_private_key.this.private_key_pem
  filename        = var.local_key_path
  file_permission = "0600"
}

# Call VPC module
module "vpc" {
  source = "./modules/vpc"

  vpc_name            = var.vpc_name
  vpc_cidr            = var.vpc_cidr
  environment         = var.environment
  aws_region          = var.aws_region
  public_cidr         = var.public_subnet_cidr
  public_subnet_2_cidr = var.public_subnet_2_cidr
  private_cidr        = var.private_subnet_cidr
  igw_name            = var.igw_name
  nat_gateway_name    = var.nat_gateway_name
  enable_nat_gateway  = var.enable_nat_gateway
}

# Call public instance module
module "public_instance" {
  source = "./modules/public-instance"

  vpc_id          = module.vpc.vpc_id
  public_subnet_id = module.vpc.public_subnet_id
  key_name        = aws_key_pair.this.key_name
  instance_type   = var.instance_type
  environment     = var.environment
  vpc_name        = var.vpc_name
}

# Call private instance module
module "private_instance" {
  source = "./modules/private-instance"

  vpc_id           = module.vpc.vpc_id
  private_subnet_id = module.vpc.private_subnet_id
  key_name         = aws_key_pair.this.key_name
  instance_type    = var.instance_type
  environment      = var.environment
  vpc_name         = var.vpc_name
  vpc_cidr         = var.vpc_cidr
  enable_nat_gateway = var.enable_nat_gateway
}

# Test SSH connection to public instance
resource "null_resource" "test_public_ssh" {
  triggers = {
    instance_id = module.public_instance.instance_id
  }

  provisioner "local-exec" {
    command = "sleep 30"
  }

  provisioner "local-exec" {
    command = <<EOT
      echo "Testing SSH connection to public instance ${module.public_instance.public_ip}..."
      ssh -o StrictHostKeyChecking=no -o ConnectTimeout=15 -i ${var.local_key_path} ec2-user@${module.public_instance.public_ip} 'echo "Public SSH Connection Successful!"'
    EOT
  }

  depends_on = [module.public_instance, local_file.private_key]
}
