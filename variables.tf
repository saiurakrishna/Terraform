#variable "access_key" {}

#variable "secret_key" {}

variable "aws_region" {
  default = "us-east-2"
}

variable "aws_resource_base_name" {
  default = "myapp"
}

variable "aws_ec2_key_name" {
  default = "myapp"
}

variable "aws_ecs_optimized_ami_id" {
  default = "ami-02e680c4540db351e"
}

variable "aws_ecs_service_desired_count" {
  default = "1"
}

