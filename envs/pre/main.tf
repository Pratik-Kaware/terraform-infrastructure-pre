provider "aws" {
    region = var.region
}
terraform {
  backend "s3" {}
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
    tags    =   var.tags
}
module "compute" {
    source  =   "git::https://github.com/Pratik-Kaware/tf-modules.git//compute"
    instance_count  =   var.instance_count
    ami =   data.aws_ami.amazon_linux.id
    instance_type   =   var.instance_type
    subnet_ids  =   module.networking.public_subnets
    environment =   var.environment
    tags    =   var.tags
  
}

module "database"{
    source  =   "git::https://github.com/Pratik-Kaware/tf-modules.git//database"
    db_name = "mydb"
    db_username = "admin"
    db_password = var.db_password
    db_instance_class = var.db_instance_class
    allocated_storage = var.allocated_storage
    subnet_ids  =   module.networking.private_subnets
    vpc_security_group_ids = [module.security.db_sg_id]
    environment = var.environment
    tags    =   var.tags

}

data "aws_ami" "amazon_linux"{
    most_recent = true
    owners  = ["amazon"]
    filter {
      name = "name"
      values = ["amzn2-ami-hvm-*-x86_64-gp2"]
    }
}