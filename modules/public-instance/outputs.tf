output "public_ip" {
  value = aws_instance.public.public_ip
}

output "private_ip" {
  value = aws_instance.public.private_ip
}

output "instance_id" {
  value = aws_instance.public.id
}
