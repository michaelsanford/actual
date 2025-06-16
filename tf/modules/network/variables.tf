variable "namespace" {
  description = "Namespace for all resources"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "Public subnet CIDRs"
  type        = list(string)
  default     = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "private_subnets" {
  description = "Private subnet CIDRs"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.11.0/24"]
}

variable "ecs_port" {
  description = "Port the ECS service listens on"
  type        = number
  default     = 5006
}

variable "alb_port" {
  description = "Port exposed by the load balancer"
  type        = number
  default     = 80
}
