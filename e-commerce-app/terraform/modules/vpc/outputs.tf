output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value       = aws_subnet.Public_Subnets_Tier[*].id
  description = "List of public subnet IDs"
}


output "private_subnet_ids" {
  value       = aws_subnet.Private_Subnets_Tier[*].id
  description = "List of private subnet IDs"
}

output "data_subnet_ids" {
  value       = aws_subnet.Data_Subnets_Tier[*].id
  description = "List of data subnet IDs"
}

output "analytics_subnet_ids" {
  value       = aws_subnet.Data_Analytics_Subnet[*].id
  description = "List of data analytics subnet IDs"
}

output "PCI_isolated_subnet_ids" {
  value       = aws_subnet.PCI_Isolated_Subnet_Tier[*].id
  description = "List of PCI isolated subnet IDs"
}

output "vpc_cidr_block" {
  value       = aws_vpc.main.cidr_block
  description = "VPC cidr block"
}
