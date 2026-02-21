variable "prefix" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "key_name" {
  type = string
}

variable "iam_instance_profile" {
  type = string
}

variable "ami_filter" {
  type    = string
  default = "amzn2-ami-ecs-hvm-*-x86_64-ebs"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "create_instance" {
  type    = bool
  default = true
}

variable "user_data_file" {
  type    = string
  default = ""
}

variable "ecs_cluster_name" {
  type = string
}

variable "public_key" {
  type    = string
  default = ""
}

variable "tags" {
  type    = map(string)
  default = {}
}
