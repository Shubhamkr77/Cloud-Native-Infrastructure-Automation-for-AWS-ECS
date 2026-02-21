terraform {
  required_version = ">= 1.2.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }

  backend "local" {}
}

provider "aws" {
  region = var.aws_region
}

# Modules
module "vpc" {
  source             = "./modules/vpc"
  prefix             = var.prefix
  cidr               = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
}

module "iam" {
  source = "./modules/iam"
  prefix = var.prefix
}

module "ecr" {
  source = "./modules/ecr"
  prefix = var.prefix
  tags   = var.tags
}

module "ec2" {
  source               = "./modules/ec2"
  prefix               = var.prefix
  instance_type        = var.instance_type
  ami_filter           = var.ami_filter
  key_name             = var.key_name
  public_key           = var.ssh_public_key
  subnet_id            = module.vpc.public_subnet_id
  vpc_id               = module.vpc.vpc_id
  ecs_cluster_name     = module.ecs.cluster_name
  user_data_file       = "${path.module}/user_data.sh"
  tags                 = var.tags
  iam_instance_profile = module.iam.ecs_instance_profile_name
}


module "ecs" {
  source       = "./modules/ecs"
  prefix       = var.prefix
  cluster_name = "${var.prefix}-cluster-${var.env}"
  tags         = var.tags
}

module "ecs_service" {
  source                      = "./modules/ecs_service"
  prefix                      = var.prefix
  cluster_name                = module.ecs.cluster_name
  ecr_repo_url                = module.ecr.repository_url
  container_port              = var.container_port
  desired_count               = var.desired_count
  task_cpu                    = var.task_cpu
  task_memory                 = var.task_memory
  iam_task_execution_role_arn = module.iam.ecs_task_execution_role_arn
  subnet_id                   = module.vpc.public_subnet_id
  security_group_id           = module.ec2.security_group_id
  aws_region                  = var.aws_region
  tags                        = var.tags
}
