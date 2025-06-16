resource "aws_ecs_cluster" "this" {
  name = "${var.namespace}-cluster"
}

resource "aws_iam_role" "task_exec" {
  name               = "${var.namespace}-task-exec"
  assume_role_policy = data.aws_iam_policy_document.ecs_task.json
}

data "aws_iam_policy_document" "ecs_task" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "exec" {
  role       = aws_iam_role.task_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_task_definition" "this" {
  family                   = "${var.namespace}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.task_exec.arn

  container_definitions = jsonencode([
    {
      name      = "sync-server"
      image     = var.container_image
      portMappings = [{ containerPort = var.port }]
      secrets = [
        { name = "DB_SECRET", valueFrom = var.db_secret_arn }
      ]
      environment = [
        { name = "ACTUAL_PORT", value = tostring(var.port) }
      ]
    }
  ])
}

resource "aws_ecs_service" "this" {
  name            = "${var.namespace}-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets         = var.subnets
    security_groups = var.security_groups
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app.arn
    container_name   = "sync-server"
    container_port   = var.port
  }
}

resource "aws_lb" "app" {
  name               = "${var.namespace}-alb"
  load_balancer_type = "application"
  subnets            = var.alb_subnets
  security_groups    = [var.alb_security_group_id]
}

resource "aws_lb_target_group" "app" {
  name     = "${var.namespace}-tg"
  port     = var.port
  protocol = "HTTP"
  target_type = "ip"
  vpc_id   = var.vpc_id
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app.arn
  port              = var.alb_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}

resource "aws_route53_record" "domain" {
  zone_id = var.zone_id
  name    = var.domain_name
  type    = "A"
  alias {
    name                   = aws_lb.app.dns_name
    zone_id                = aws_lb.app.zone_id
    evaluate_target_health = false
  }
}
