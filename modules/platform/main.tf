module "vpc" {
  source = "../vpc"

  name               = var.name
  cidr_block         = var.vpc_cidr
  az_count           = var.az_count
  single_nat_gateway = var.single_nat_gateway
  cluster_name       = var.name
  tags               = var.tags
}

module "eks" {
  source = "../eks"

  name                         = var.name
  kubernetes_version           = var.kubernetes_version
  vpc_id                       = module.vpc.vpc_id
  private_subnets              = module.vpc.private_subnet_ids
  endpoint_public_access_cidrs = var.eks_public_access_cidrs
  tags                         = var.tags
}
