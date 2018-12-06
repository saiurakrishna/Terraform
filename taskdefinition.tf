# ECS Task
resource "aws_ecs_task_definition" "myapp" {
  family = "${var.aws_resource_base_name}"
  requires_compatibilities = ["EC2","FARGATE"]
  network_mode = "awsvpc"
  cpu = 512
  memory = 1024
  execution_role_arn = "${aws_iam_role.ecs_service_role.arn}"
  container_definitions = "${file("service.json")}"
}

