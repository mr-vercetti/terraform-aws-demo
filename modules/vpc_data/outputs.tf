output "vpc" {
  value = data.aws_vpc.vpc
}

output "public_subnets" {
  value = data.aws_subnets.public_subnets
}

output "private_subnets" {
  value = data.aws_subnets.private_subnets
}

output "bastion_host_subnet" {
  value = data.aws_subnet.bastion_host_subnet
}