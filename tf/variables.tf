variable "region" {
  description = "AWS region"
  type        = string
  default     = "ca-central-1"
}

variable "namespace" {
  description = "Namespace prefix for resources"
  type        = string
}

variable "container_image" {
  description = "Docker image for sync-server"
  type        = string
  default     = "actualbudget/actual-server:latest"
}

variable "zone_id" {
  description = "Route53 hosted zone id"
  type        = string
}

variable "domain_name" {
  description = "Domain name to attach to the service"
  type        = string
}
