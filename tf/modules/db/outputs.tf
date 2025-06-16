output "db_endpoint" {
  value = aws_rds_cluster.this.endpoint
}

output "secret_arn" {
  value = aws_secretsmanager_secret.creds.arn
}
