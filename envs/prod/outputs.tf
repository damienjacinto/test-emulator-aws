output "vpc_id" {
  description = "VPC ID."
  value       = module.platform.vpc_id
}

output "private_subnet_ids" {
  description = "Private subnet IDs."
  value       = module.platform.private_subnet_ids
}

output "cluster_name" {
  description = "EKS cluster name."
  value       = module.platform.cluster_name
}

output "cluster_endpoint" {
  description = "EKS API server endpoint."
  value       = module.platform.cluster_endpoint
}
