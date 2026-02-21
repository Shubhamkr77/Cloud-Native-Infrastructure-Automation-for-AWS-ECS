# Generate a container definition using the ECR repo and a default tag 'latest'
locals {
  container_definitions = [
    {
      name   = "${var.prefix}-container"
      image  = "${var.ecr_repo_url}:latest"
      cpu    = var.task_cpu
      memory = var.task_memory
      essential = true
      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/${var.prefix}"
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ]
}

# create the CloudWatch Logs group for task logs
resource "aws_cloudwatch_log_group" "ecs" {
  name = "/ecs/${var.prefix}"
  retention_in_days = 7
}

resource "aws_ecs_task_definition" "this" {
  family                   = "${var.prefix}-task"
  network_mode             = "bridge"
  requires_compatibilities = ["EC2"]
  cpu                      = tostring(var.task_cpu)
  memory                   = tostring(var.task_memory)
  execution_role_arn       = var.iam_task_execution_role_arn

  container_definitions = jsonencode(local.container_definitions)
}

resource "aws_ecs_service" "this" {
  name            = "${var.prefix}-service"
  cluster         = var.cluster_name
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = var.desired_count
  launch_type     = "EC2"

  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent = 200

  tags = merge({ Name = "${var.prefix}-service" }, var.tags)
}
