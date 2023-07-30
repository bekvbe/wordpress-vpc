variable "ami" {
  description = "AMI Amazon Linux 2023"
  type        = string
  default     = "ami-04a1c5890e49a379b"
}

variable "instance_type" {
  description = "The type of EC2 istance"
  type        = string
  default     = "t2.micro"
}
#VPC configs
variable "main_vpc_cidr" {

}
#SG confings
variable "sg_description" {
  default = "This is a task #3"
}
variable "sg_name" {
  default = "wordpress-sg"
}

variable "rds_description" {
  default = "This is a security group for RDS"
}
