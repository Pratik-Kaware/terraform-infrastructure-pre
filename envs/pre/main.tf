provider "aws" {
    region = var.region
}

module "networking" {
    source  = "git::https://github.com/Pratik-Kaware/tf-modules.git//networking"
    vpc_cidr    = var.vpc_cidr
    public_subnets  = var.public_subnets
    azs = var.azs
    environment = var.environment
    tags    = var.tags
}

module "security"{
    source  =   "git::https://github.com/Pratik-Kaware/tf-modules.git//security"
    vpc_id  =   module.networking.vpc_id
    environment = var.environment
    tags    =   env.tags
}
module "compute" {
    source  =   "git::https://github.com/Pratik-Kaware/tf-modules.git//compute"
    instance_count  =   var.instance_count
    ami =   data.aws_ami.amazon_linux.id
    instance_type   =   var.instance_type
    subnet_ids  =   module.networking.public_subnets
    key_pair_name   =   var.key_pair_name
    environment =   var.environment
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