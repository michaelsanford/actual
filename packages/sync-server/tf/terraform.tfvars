# Project Configuration
project_name = "actual"
environment  = "prod"

# Network Configuration
vpc_cidr = "10.0.0.0/16"
availability_zones = ["ca-central-1a", "ca-central-1d"]

# Application Configuration
app_name = "actual-budget"
container_image = "actualbudget/actual-server:latest"
container_port = 5006
cpu = 512
memory = 1024

# Domain Configuration
domain_name = "fin.michaelsanford.com"
hosted_zone_name = "michaelsanford.com"

# EFS Configuration
efs_throughput_mode = "provisioned"
efs_provisioned_throughput = 10

# Application Environment Variables
app_config = {
  ACTUAL_DATA_DIR = "/data"
  ACTUAL_CONFIG_PATH = "/config/config.json"
  ACTUAL_HOSTNAME = "0.0.0.0"
  ACTUAL_LOGIN_METHOD = "password"
  ACTUAL_ALLOWED_LOGIN_METHODS = "password"
}

# Tags
common_tags = {
  project = "actual"
  terraform = "true"
}
