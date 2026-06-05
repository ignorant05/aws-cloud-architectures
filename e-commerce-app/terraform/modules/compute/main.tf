resource "aws_lb" "public_alb" {
  name               = "${var.environment}-public-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.public_alb_sg_id]
  subnets            = var.public_subnet_ids
}

resource "aws_lb_target_group" "ecs_target" {
  name        = "${var.environment}-ecs-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path     = "/health"
    matcher  = "200"
    interval = 30
    timeout  = 5
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.public_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_target.arn
  }
}

resource "aws_ecs_cluster" "main" {
  name = "${var.environment}-ecs-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_task_definition" "app_task" {
  for_each                 = toset(["search", "product", "cart", "order"])
  family                   = "${var.environment}-${each.key}-service"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = var.ecs_exec_role_arn
  task_role_arn            = var.ecs_task_role_arn

  container_definitions = jsonencode([{
    name      = "${each.key}-container"
    image     = "${var.container_registry_url}/${each.key}:latest"
    essential = true
    portMappings = [{
      containerPort = 80
      hostPort      = 80
    }]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = var.cloudwatch_log_group_name
        "awslogs-region"        = var.aws_region
        "awslogs-stream-prefix" = each.key
      }
    }
  }])
}

resource "aws_ecs_service" "services" {
  for_each        = toset(["search", "product", "cart", "order"])
  name            = "${var.environment}-${each.key}-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app_task[each.key].arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [var.ecs_tasks_sg_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_target.arn
    container_name   = "${each.key}-container"
    container_port   = 80
  }
}
resource "aws_launch_template" "workers" {
  name_prefix   = "${var.environment}-worker-"
  image_id      = var.ami_id
  instance_type = var.instance_type

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [var.worker_sg_id]
  }

  tag_specifications {
    resource_type = "instance"
    tags          = { Name = "${var.environment}-web-worker" }
  }
}

resource "aws_autoscaling_group" "web_servers" {
  name                = "${var.environment}-web-servers-asg"
  vpc_zone_identifier = var.private_subnet_ids
  desired_capacity    = 3
  min_size            = 2
  max_size            = 5

  launch_template {
    id      = aws_launch_template.workers.id
    version = "$Latest"
  }
}
