resource "time_rotating" "db_rotation" {
  rotation_days = 7
}

resource "random_password" "db" {
  length  = 40
  special = true
  keepers = {
    rotation = time_rotating.db_rotation.id
  }
}

resource "aws_secretsmanager_secret" "creds" {
  name = "${var.namespace}-db-creds"
}

resource "aws_secretsmanager_secret_version" "creds" {
  secret_id     = aws_secretsmanager_secret.creds.id
  secret_string = jsonencode({ username = var.db_username, password = random_password.db.result })
}

resource "aws_rds_cluster" "this" {
  cluster_identifier = "${var.namespace}-cluster"
  engine             = "aurora-postgresql"
  engine_mode        = "provisioned"
  master_username    = var.db_username
  master_password    = random_password.db.result
  database_name      = "actual"
  db_subnet_group_name = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.db.id]

  serverlessv2_scaling_configuration {
    min_capacity = 0
    max_capacity = 2
  }
}

resource "aws_rds_cluster_instance" "this" {
  count               = 1
  identifier          = "${var.namespace}-instance-${count.index}"
  cluster_identifier  = aws_rds_cluster.this.id
  instance_class      = "db.serverless"
  engine              = aws_rds_cluster.this.engine
}

resource "aws_db_subnet_group" "this" {
  name       = "${var.namespace}-subnets"
  subnet_ids = var.subnets
}

resource "aws_security_group" "db" {
  name   = "${var.namespace}-db"
  vpc_id = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.namespace}-db" }
}
