variable "project_name" {
    description = "Project name"
    type        = string
}

variable "vpc_id" {
    description = "ID of the VPC"
    type        = string
}

variable "public_subnet_1_id" {
    description = "ID of the public subnet 1"
    type        = string
}

variable "public_subnet_2_id" {
    description  = "ID of the public subnet 2"
    type         = string
}

variable "ami_id" {
    description  = "AMI ID of EC2"
    type         = string
}

variable "instance_type" {
    description  = "instance type"
    type        = string
}

variable "target_group_arn" {
    description = "arn of the target group"
    type        = string
}

variable "min_size" {
    description = "minimum number of EC2 server"
    type        = number
}

variable "max_size" {
    description = "maximum number of EC2 server"
    type        = number
}

variable "desired_capacity" {
    description = "desired capacity of the server"
    type        = number
}