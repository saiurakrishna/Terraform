# ECS Cluster
resource "aws_ecs_cluster" "myapp" {
  name = "${var.aws_resource_base_name}"
}

# ECS Service
resource "aws_ecs_service" "myapp" {
  cluster                            = "${aws_ecs_cluster.myapp.id}"
  deployment_minimum_healthy_percent = 100
  desired_count                      = "${var.aws_ecs_service_desired_count}"
  #iam_role                           = "arn:aws:iam::453093980721:role/aws-service-role/ecs.amazonaws.com/AWSServiceRoleForECS"
  name                               = "${var.aws_resource_base_name}"
  task_definition                    = "${aws_ecs_task_definition.myapp.arn}"
  launch_type = "FARGATE"
  load_balancer {
    container_name   = "${var.aws_resource_base_name}"
    container_port   = "7777"
    target_group_arn = "${aws_alb_target_group.myapp.arn}"
  }
  network_configuration {
    subnets = ["${aws_subnet.myapp_public_a.id}"]
    security_groups = ["${aws_security_group.myapp.id}"]
    assign_public_ip = true
  }
}

