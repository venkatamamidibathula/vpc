output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = module.vpc.public_subnet_id
}

output "public_subnet_2_id" {
  description = "ID of the second public subnet"
  value       = module.vpc.public_subnet_2_id
}

output "private_subnet_id" {
  description = "ID of the private subnet"
  value       = module.vpc.private_subnet_id
}

output "public_instance_public_ip" {
  description = "Public IP address of the public EC2 instance"
  value       = module.public_instance.public_ip
}

output "private_instance_private_ip" {
  description = "Private IP address of the private EC2 instance"
  value       = module.private_instance.private_ip
}

output "nat_gateway_id" {
  description = "ID of the NAT Gateway"
  value       = module.vpc.nat_gateway_id
}

output "nat_gateway_public_ip" {
  description = "Public IP of the NAT Gateway"
  value       = module.vpc.nat_gateway_public_ip
}

output "public_ssh_command" {
  description = "SSH command to connect to the public instance"
  value       = "ssh -i ${var.local_key_path} ec2-user@${module.public_instance.public_ip}"
}

output "private_ssh_via_bastion" {
  description = "SSH command to connect to private instance via public instance"
  value       = "ssh -i ${var.local_key_path} -J ec2-user@${module.public_instance.public_ip} ec2-user@${module.private_instance.private_ip}"
}

output "private_instance_has_internet" {
  description = "Whether private instance has internet access via NAT Gateway"
  value       = var.enable_nat_gateway ? "Yes" : "No"
}

output "private_key_saved_path" {
  description = "Path where the private key was saved"
  value       = local_file.private_key.filename
}

output "key_pair_name" {
  description = "Name of the created key pair in AWS"
  value       = aws_key_pair.this.key_name
}
