region  =   "ap-south-1"
environment =   "pre"
vpc_cidr =  "10.0.0.0/16"
public_subnets = [ "10.0.1.0/24" ]
azs = [ 
  "ap-south-1a",
  "ap-south-1b",
  "ap-south-1c"
   ]
instance_count = 2
instance_type = "t2.micro"
key_pair_name = "your-key-name"

tags = {
  Project = "enterprise-startup"
  Owner = "devops"
  Environment = "pre"
  ManagedBy =   "terraform"
}