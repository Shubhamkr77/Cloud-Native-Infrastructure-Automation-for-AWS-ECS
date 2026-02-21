variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "prefix" {
  description = "Resource name prefix"
  type        = string
  default     = "terraform-demo"
}

variable "env" {
  description = "Environment (dev, integ, prod)"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "Public subnet CIDR"
  type        = string
  default     = "10.0.1.0/24"
}

variable "instance_type" {
  description = "EC2 instance type (t3.micro for free tier)"
  type        = string
  default     = "t3.micro"
}

variable "ami_filter" {
  description = "AMI name pattern for ECS-optimized Amazon Linux 2"
  default     = "amzn2-ami-ecs-hvm-*-x86_64-ebs"
}


variable "key_name" {
  description = "Name for the AWS key pair to create. If you provide a name that already exists Terraform will error. You can set this blank and provide an existing key via ssh_public_key."
  type        = string
  default     = "terraform_demo_key"
}

variable "ssh_public_key" {
  description = "Your SSH public key material (ssh-rsa AAAAB3Nza...). Terraform will create an aws_key_pair from this."
  type        = string
  default     = "" # put your public key in terraform.tfvars
}

variable "container_port" {
  description = "Port the container exposes"
  type        = number
  default     = 8080
}

variable "desired_count" {
  description = "Desired number of tasks (service)"
  type        = number
  default     = 1
}

variable "task_cpu" {
  description = "Task CPU units for container definition"
  type        = number
  default     = 256
}

variable "task_memory" {
  description = "Task memory (MiB)"
  type        = number
  default     = 512
}

variable "tags" {
  description = "Tags map"
  type        = map(string)
  default = {
    Owner       = "devteam"
    Environment = "dev"
  }
}
