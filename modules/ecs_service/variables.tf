variable "prefix" { 
    type = string 
}

variable "cluster_name" { 
    type = string 
}

variable "ecr_repo_url" { 
    type = string 
}

variable "container_port" { 
    type = number 
    default = 8080 
}

variable "desired_count" { 
    type = number 
    default = 1 
}

variable "task_cpu" { 
    type = number 
    default = 256 
}

variable "task_memory" { 
    type = number 
    default = 512 
}

variable "iam_task_execution_role_arn" { 
    type = string 
}

variable "security_group_id" { 
    type = string 
}

variable "subnet_id" { 
    type = string 
}

variable "tags" { 
    type = map(string) 
    default = {} 
}

variable "aws_region" {
  description = "AWS region where ECS service is deployed"
  type        = string
}
