output "demo_vpc_id" {
  value       = module.vpc_data.vpc.id
}

output "public_subnets" {
  value = module.vpc_data.public_subnets.ids
}

output "private_subnets" {
  value = module.vpc_data.private_subnets.ids
}

output "demo_bastion_host_subnet_id" {
  value       = module.vpc_data.bastion_host_subnet.id
}

output "demo_bastion_host_private_ip" {
  value = module.bastion_host.bastion_host_private_ip
}

output "demo_bastion_host_public_ip" {
  value = module.bastion_host.bastion_host_public_ip
}