output "bastion_host_private_ip" {
  value = aws_instance.this.private_ip
}

output "bastion_host_public_ip" {
  value = aws_instance.this.public_ip
}