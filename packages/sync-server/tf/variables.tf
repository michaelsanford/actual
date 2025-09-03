variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "app_name" {
  description = "Application name"
  type        = string
}

variable "container_image" {
  description = "Docker image for the application"
  type        = string
}

variable "container_port" {
  description = "Port the container listens on"
  type        = number
}

variable "cpu" {
  description = "CPU units for Fargate task"
  type        = number
}

variable "memory" {
  description = "Memory in MB for Fargate task"
  type        = number
}

variable "domain_name" {
  description = "Domain name for the application"
  type        = string
}

variable "hosted_zone_name" {
  description = "Route53 hosted zone name"
  type        = string
}

variable "efs_throughput_mode" {
  description = "EFS throughput mode"
  type        = string
  default     = "provisioned"
}

variable "efs_provisioned_throughput" {
  description = "EFS provisioned throughput in MiB/s"
  type        = number
  default     = 10
}

variable "app_config" {
  description = "Application configuration environment variables"
  type        = map(string)
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
}
