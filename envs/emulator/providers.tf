terraform {
  required_version = ">= 1.10.0" # S3 backend use_lockfile

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.59"
    }
  }
}

provider "aws" {
  region = local.region

  # Safety net: refuses to run against any account other than the emulator's,
  allowed_account_ids = ["000000000000"]

  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_region_validation      = true
  s3_use_path_style           = true

  default_tags {
    tags = local.tags
  }
}
