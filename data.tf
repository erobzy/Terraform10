data "aws_ami" "ubuntu_ami" {
  most_recent      = true
  owners           = ["amazon"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}



data "aws_key_pair" "my_keypair" {
  key_name           = "aws_demo"
}


data "aws_region" "current" {}

data "aws_caller_identity" "current" {}