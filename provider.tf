provider "aws" {
  region     = var.region
  profile    = var.aws_profile
  access_key = var.access_key
  secret_key = var.secret_key
}
