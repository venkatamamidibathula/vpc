variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-west-2"
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "vpca"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.100.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.100.1.0/24"
}

variable "public_subnet_2_cidr" {
  description = "CIDR block for the second public subnet (for NAT Gateway)"
  type        = string
  default     = "10.100.2.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  type        = string
  default     = "10.100.11.0/24"
}

variable "igw_name" {
  description = "Name of the Internet Gateway"
  type        = string
  default     = "igwa"
}

variable "nat_gateway_name" {
  description = "Name of the NAT Gateway"
  type        = string
  default     = "VPC-NATGW"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Name of the key pair for EC2 instance"
  type        = string
  default     = "vpckey"
}

variable "environment" {
  description = "Environment tag"
  type        = string
  default     = "dev"
}

variable "local_key_path" {
  description = "Path to save the private key locally"
  type        = string
  default     = "./vpckey.pem"
}

variable "enable_nat_gateway" {
  description = "Whether to create NAT Gateway for private subnet internet access"
  type        = bool
  default     = true
}
