terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
    time = {
      source  = "hashicorp/time"
      version = ">= 0.10"
    }
  }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      "actual-budget" = var.namespace
    }
  }
}

provider "time" {}

module "network" {
  source = "./modules/network"
  namespace = var.namespace
}

module "database" {
  source  = "./modules/db"
  namespace = var.namespace
  subnets   = module.network.private_subnets
  vpc_id    = module.network.vpc_id
}

module "ecs" {
  source          = "./modules/ecs"
  namespace       = var.namespace
  subnets                = module.network.public_subnets
  security_groups        = [module.network.ecs_security_group_id]
  vpc_id                 = module.network.vpc_id
  alb_subnets            = module.network.public_subnets
  alb_security_group_id  = module.network.alb_security_group_id
  db_secret_arn          = module.database.secret_arn
  container_image        = var.container_image
  zone_id                = var.zone_id
  domain_name            = var.domain_name
}

output "service_name" {
  value = module.ecs.service_name
}
