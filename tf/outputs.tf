output "vpc_id" {
  value = module.network.vpc_id
}

output "db_endpoint" {
  value = module.database.db_endpoint
}

output "ecs_service" {
  value = module.ecs.service_name
}

output "alb_dns_name" {
  value = module.ecs.alb_dns_name
}
