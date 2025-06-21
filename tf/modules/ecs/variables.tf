variable "namespace" {
  description = "Namespace"
  type        = string
}

variable "subnets" {
  description = "Subnet ids"
  type        = list(string)
}

variable "security_groups" {
  description = "Security groups for tasks"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC id"
  type        = string
}

variable "alb_subnets" {
  description = "Subnets for the ALB"
  type        = list(string)
}

variable "alb_security_group_id" {
  description = "Security group for the ALB"
  type        = string
}

variable "zone_id" {
  description = "Route53 hosted zone id"
  type        = string
}

variable "domain_name" {
  description = "Domain to associate with ALB"
  type        = string
}

variable "alb_port" {
  description = "Port for ALB listener"
  type        = number
  default     = 80
}

variable "db_secret_arn" {
  description = "ARN of database secret"
  type        = string
}

variable "container_image" {
  description = "Container image"
  type        = string
  default     = "actualbudget/actual-server:latest"
}

variable "port" {
  description = "Container port"
  type        = number
  default     = 5006
}
