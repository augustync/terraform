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

//resource "aws_default_vpc" "vpc" {}

resource "aws_security_group" "sg_web"{
  name        = "sg_web"
  description = "Allow standard http and https ports inbound everything outbound"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Terraform" : "true"
  }
}

// ami-03e2ce3ac31c06bff t2.nano

resource "aws_instance" "web_app" {
  count         = 2

  ami           = "ami-03e2ce3ac31c06bff"
  instance_type = "t2.nano"

  vpc_security_group_ids = [
    aws_security_group.sg_web.id
  ]

  tags = {
    "Terraform" : "true"
  }
}

/*on tf_code_s3.tf line 71, in resource "aws_eip" "web":
  71:   instance = aws_instance.web_app.id

Because aws_instance.web_app has "count" set, its attributes must be accessed
on specific instances.

For example, to correlate with indices of a referring resource, use:
    aws_instance.web_app[count.index]

-- fix
instance = aws_instance.web_app.0.id
*/

resource "aws_eip" "web" {
  instance = aws_instance.web_app.0.id
  tags = {
    "Terraform" : "true"
  }
}

resource "aws_eip_association" "web" {
  instance_id     = aws_instance.web_app.0.id
  allocation_id   = aws_eip.web.id
}

resource "aws_default_subnet" "az1" {
  availability_zone = "us-west-2a"

  tags = {
    "Terraform" : "true"
  }
}

resource "aws_default_subnet" "az2" {
  availability_zone = "us-west-2b"

  tags = {
    "Terraform" : "true"
  }
}

resource "aws_elb" "web" {
  name            = "web-elb"
  instances       = aws_instance.web_app.*.id
  subnets         = [aws_default_subnet.az1.id, aws_default_subnet.az2.id]
  security_groups = [aws_security_group.sg_web.id]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
}

