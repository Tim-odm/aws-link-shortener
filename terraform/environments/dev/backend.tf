# Remote state tracking
terraform {
  backend "s3" {
    bucket       = "YOUR-STATE-BUCKET-NAME"
    key          = "dev/terraform.tfstate"
    region       = "eu-west-2"
    use_lockfile = true
  }
}
