# Remote state tracking
terraform {
  backend "s3" {
    bucket       = "link-shortener-tfstate-025066244750"
    key          = "dev/terraform.tfstate"
    region       = "eu-west-2"
    use_lockfile = true
  }
}
