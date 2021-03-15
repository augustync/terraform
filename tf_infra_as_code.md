# Infrastructure as Code

## Explaining the Code Structure

### Resources

* Building blocks of Terraform code
* Define the "what" of your infrastructure
* Different settings for provider

```terraform
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
```

### Basic resource types base on AWS

* `aws_s3_bucket` for S3 buckets
* `aws_default_vpc` for the VPC
* `aws_security_group` for SG rules
  * ingress block - define which protocol, ports, IP can get in (inbound)
  * egress block - define which protocol, ports, IP can get out (outband)
* `aws_instance` for Ec2 instances (VM's)
  * `instance_type` - define the EC2 instance type/size
  * `ami` - define which image to use for the EC2 instance
* `aws_eip` for static public IP address

### 
