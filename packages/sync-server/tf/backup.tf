# AWS Backup Vault
resource "aws_backup_vault" "efs" {
  name = "${local.name_prefix}-efs-backup-vault"

  tags = merge(var.common_tags, {
    Name = "${local.name_prefix}-efs-backup-vault"
  })
}

# AWS Backup Plan
resource "aws_backup_plan" "efs" {
  name = "${local.name_prefix}-efs-weekly-backup"

  rule {
    rule_name         = "WeeklyBackup"
    target_vault_name = aws_backup_vault.efs.name
    schedule          = "cron(0 7 ? * MON *)" # Mondays at 2 AM Montreal time (7 AM UTC)

    lifecycle {
      delete_after = 30
    }

    recovery_point_tags = merge(var.common_tags, {
      backup-type = "weekly"
    })
  }

  tags = merge(var.common_tags, {
    Name = "${local.name_prefix}-efs-weekly-backup"
  })
}

# AWS Backup Selection
resource "aws_backup_selection" "efs" {
  iam_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/service-role/AWSBackupDefaultServiceRole"
  name         = "${local.name_prefix}-efs-selection"
  plan_id      = aws_backup_plan.efs.id

  resources = [
    aws_efs_file_system.main.arn
  ]
}

# Data source for account ID
data "aws_caller_identity" "current" {}
