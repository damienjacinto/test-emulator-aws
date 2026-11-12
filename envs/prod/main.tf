locals {
  environment = "prod"
  region      = "us-east-1"
  name        = "test-${local.environment}"

  tags = {
    Environment = local.environment
    Project     = "test"
    ManagedBy   = "terraform"
    Owner       = "platform-team"
  }
}

module "platform" {
  source = "../../modules/platform"

  name               = local.name
  vpc_cidr           = "10.1.0.0/16"
  az_count           = 3
  single_nat_gateway = false # one NAT per AZ: survives an AZ outage
  kubernetes_version = "1.35"

  # Restrict to your own IP / VPN range
  eks_public_access_cidrs = ["203.0.113.10/32"]

  tags = local.tags
}
