variable "namespace" {
  description = "Namespace for resources"
  type        = string
}

variable "subnets" {
  description = "Subnets for the database"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC id"
  type        = string
}

variable "db_username" {
  description = "Master database username"
  type        = string
  default     = "actual"
}
