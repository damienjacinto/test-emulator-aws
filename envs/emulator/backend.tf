terraform {
  backend "s3" {
    bucket       = "tf-state-emulator"
    key          = "test/emulator/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true

    # Pinned explicitly so state can never end up in real AWS
    endpoints = {
      s3 = "https://127.0.0.1:9297"
    }
    use_path_style              = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
  }
}
