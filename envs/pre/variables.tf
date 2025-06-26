variable "region" {}
variable "env" {}
variable "vpc_cidr" {}
variable "public_subnets"{
    type = list(string)
}
variable "azs"{
    type = list(string)
}
variable "instance_count" {}
variable "instance_type" {}
variable "key_pair_name" {}
variable "tags" {
    type = map(string)
}

