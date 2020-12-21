resource "aws_ecs_cluster" "webapp" {
  name = "webapp"
}

resource "aws_lb" "webapp" {
  name            = "webapp"
  subnets         = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
  security_groups = [aws_security_group.default.id]
}

resource "aws_lb_target_group" "webapp" {
  name        = "webapp"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.default.id
  target_type = "instance"
}

resource "aws_lb_listener" "webapp" {
  load_balancer_arn = aws_lb.webapp.id
  port              = 80
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_lb_target_group.webapp.id
    type             = "forward"
  }
}

resource "aws_ecs_service" "webapp" {
  name            = "webapp"
  cluster         = aws_ecs_cluster.webapp.id
  task_definition = aws_ecs_task_definition.webapp.arn
  desired_count   = 2
  load_balancer {
    target_group_arn = aws_lb_target_group.webapp.id
    container_name   = "webapp"
    container_port   = 80
  }
}

resource "aws_ecs_task_definition" "webapp" {
  family       = "webapp"
  network_mode = "bridge"
  cpu          = 1024
  memory       = 600
  container_definitions = templatefile("task-definitions/webapp.json", {
    database_host     = aws_db_instance.database.endpoint,
    database_name     = var.database_name,
    database_user     = var.database_user,
    database_password = var.database_password,
  })
}

resource "aws_autoscaling_group" "webapp" {
  name                 = "webapp"
  min_size             = 1
  max_size             = 3
  desired_capacity     = 2
  vpc_zone_identifier  = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
  launch_configuration = aws_launch_configuration.webapp.name
  health_check_type    = "ELB"
}

resource "aws_launch_configuration" "webapp" {
  name                        = "webapp"
  image_id                    = data.aws_ami.ecs.id
  instance_type               = "t2.micro"
  iam_instance_profile        = aws_iam_instance_profile.instance.id
  security_groups             = [aws_security_group.default.id]
  associate_public_ip_address = true
  user_data                   = <<EOF
                                  #!/bin/bash
                                  sudo yum update -y
                                  echo ECS_CLUSTER=${aws_ecs_cluster.webapp.id} >> /etc/ecs/ecs.config
                                  EOF
  depends_on                  = [aws_ecs_cluster.webapp]
}
