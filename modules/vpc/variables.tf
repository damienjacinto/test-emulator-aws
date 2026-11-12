variable "name" {
  description = "Name prefix for VPC resources."
  type        = string
}

variable "cidr_block" {
  description = "The CIDR block for the VPC."
  type        = string
}

variable "az_count" {
  description = "Number of availability zones to create subnets in."
  type        = number
  default     = 2
}

variable "cluster_name" {
  description = "EKS cluster name, used for subnet discovery tags. Leave null if no cluster uses this VPC."
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags applied to all resources created by this module."
  type        = map(string)
  default     = {}
}

variable "single_nat_gateway" {
  description = "Use one shared NAT gateway (cheap, dev) instead of one per AZ (highly available, prod)."
  type        = bool
  default     = true
}
