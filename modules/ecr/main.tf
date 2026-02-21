resource "aws_ecr_repository" "this" {
  name = "${var.prefix}-repo"
  image_tag_mutability = "MUTABLE"
  tags = merge({ Name = "${var.prefix}-ecr" }, var.tags)
}


