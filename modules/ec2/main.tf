###################################
# SECURITY GROUP
###################################
resource "aws_security_group" "this" {
  name        = "${var.prefix}-sg"
  description = "Allow SSH and app port"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "App port"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge({ Name = "${var.prefix}-sg" }, var.tags)
}

###################################
# KEY PAIR (optional)
###################################
resource "aws_key_pair" "this" {
  count      = var.public_key != "" ? 1 : 0
  key_name   = var.key_name
  public_key = var.public_key
}

###################################
# ECS OPTIMIZED AMI
###################################
data "aws_ami" "ecs_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = [var.ami_filter]
  }
}

###################################
# EC2 INSTANCE
###################################
resource "aws_instance" "this" {
  count                       = var.create_instance ? 1 : 0
  ami                         = data.aws_ami.ecs_ami.id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.this.id]
  iam_instance_profile        = var.iam_instance_profile

  key_name = var.public_key != "" ? aws_key_pair.this[0].key_name : var.key_name

  user_data = var.user_data_file != "" ? templatefile(var.user_data_file, {
    ecs_cluster_name = var.ecs_cluster_name
  }) : ""

  tags = merge({ Name = "${var.prefix}-ec2" }, var.tags)
}
