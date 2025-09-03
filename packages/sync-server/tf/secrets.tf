# Secrets Manager Secret
resource "aws_secretsmanager_secret" "app_config" {
  name        = "${local.name_prefix}-config"
  description = "Configuration secrets for ${var.app_name} application"

  tags = merge(var.common_tags, {
    Name = "${local.name_prefix}-config"
  })
}

resource "aws_secretsmanager_secret_version" "app_config" {
  secret_id     = aws_secretsmanager_secret.app_config.id
  secret_string = jsonencode(var.app_config)
}
