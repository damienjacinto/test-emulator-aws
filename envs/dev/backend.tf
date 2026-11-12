terraform {
  backend "s3" {
    bucket       = "CHANGE-ME-terraform-state-dev"
    key          = "test/dev/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}
