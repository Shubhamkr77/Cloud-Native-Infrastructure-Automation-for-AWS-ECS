output "ecr_repo_url" {
  value = module.ecr.repository_url
}

output "ec2_public_ip" {
  value = module.ec2.instance_public_ip
}

output "ecs_cluster_name" {
  value = module.ecs.cluster_name
}

output "ecs_service_name" {
  value = module.ecs_service.service_name
}
