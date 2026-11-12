variable "name" {
  description = "The name of the EKS cluster."
  type        = string
}

variable "kubernetes_version" {
  description = "The Kubernetes version for the EKS cluster."
  type        = string
  default     = "1.35"
}

variable "vpc_id" {
  description = "The ID of the VPC where the EKS cluster is deployed."
  type        = string
}

variable "private_subnets" {
  description = "Private subnet IDs for the cluster and its nodes (at least two AZs)."
  type        = list(string)
}

variable "endpoint_public_access_cidrs" {
  description = "CIDR blocks allowed to reach the public API endpoint."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "tags" {
  description = "Tags to apply to the EKS cluster."
  type        = map(string)
  default     = {}
}
