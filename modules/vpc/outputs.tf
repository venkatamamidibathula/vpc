output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_id" {
  value = aws_subnet.public.id
}

output "public_subnet_2_id" {
  value = var.enable_nat_gateway ? aws_subnet.public_2[0].id : null
}

output "private_subnet_id" {
  value = aws_subnet.private.id
}

output "nat_gateway_id" {
  value = var.enable_nat_gateway ? aws_nat_gateway.main[0].id : null
}

output "nat_gateway_public_ip" {
  value = var.enable_nat_gateway ? aws_eip.nat[0].public_ip : null
}
