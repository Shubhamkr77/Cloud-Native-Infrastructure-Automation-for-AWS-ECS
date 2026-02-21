output "security_group_id" {
  value = aws_security_group.this.id
}

output "instance_public_ip" {
  value = try(aws_instance.this[0].public_ip, "")
}

output "instance_id" {
  value = try(aws_instance.this[0].id, "")
}
