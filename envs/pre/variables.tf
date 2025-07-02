variable "region" {}
variable "environment" {
    type = string
}
variable "vpc_cidr" {}
variable "public_subnets"{
    type = list(string)
}
variable "azs"{
    type = list(string)
}
variable "instance_count" {}
variable "instance_type" {}
variable "tags" {
    type = map(string)
}

