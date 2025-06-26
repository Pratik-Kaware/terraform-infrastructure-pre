provider "aws" {
    region = var.region
}

module "networking" {
    source  = "https://github.com/Pratik-Kaware/tf-modules/tree/main/networking"
    vpc_cidr    = var.vpc_cidr
    public_subnets  = var.azs
    environment = var.env
    tags    = var.tags
}

module "compute" {
    source  =   ""
    instance_count  =   var.instance_count
    ami =   data.aws_ami.amazon_linux.id
    instance_type   =   var.instance_type
    subnet_ids  =   module.networking.public_subnets
    key_pair_name   =   var.key_pair_name
    environment =   var.env
    tags    =   var.tags
  
}

data "aws_ami" "amazon_linux"{
    most_recent = true
    owners  = ["amazon"]
    filter {
      name = "name"
      values = ["myami-*"]
    }
}