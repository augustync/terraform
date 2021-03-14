provider "aws" {
    profile = var.profile
    region = var.region
}

variable "region" {
  type    = string
  default = "us-east-2"
}

variable "profile" {
  type    = string
  default = "Sandbox_InfraDeployer"
}


resource "aws_s3_bucket" "s3" {
  bucket = "auggie-sandbox-tf-tests"
  acl    = "private"
}