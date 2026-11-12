locals {
  environment = "emulator"
  region      = "us-east-1"
  name        = "test-${local.environment}"

  tags = {
    Environment = local.environment
    Project     = "test"
    ManagedBy   = "terraform"
  }
}

module "vpc" {
  source = "../../modules/vpc"

  name               = local.name
  cidr_block         = "10.0.0.0/16"
  az_count           = 2
  single_nat_gateway = true
  tags               = local.tags
}
