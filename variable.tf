variable my-current-region {
    type = string
    description = "region where my infrastructure should be deployed"
    default = "us-east-1"
}

variable my-vpc-cidr  {
    type = string
    description = "cidr range for infra"
    default = "10.0.0.0/16"
}

variable "public_subnet" {
    default = ["10.0.1.0/24" , "10.0.2.0/24"]
}

variable "private_subnet" {
  default = ["10.0.3.0/24" , "10.0.4.0/24"]

}

variable "default-keypair" {
    type = string
    description = "key pair to log in"
    default = "aws_demo"
}