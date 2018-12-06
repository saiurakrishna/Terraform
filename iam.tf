# IAM For ECS instance
resource "aws_iam_role" "ecs_instance_role" {
    name = "ecs_instance_role"
    assume_role_policy = <<-JSON
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": "sts:AssumeRole",
          "Effect": "Allow",
          "Principal": {
            "Service": "ec2.amazonaws.com"
          }
        }
      ]
    }
    JSON
}

# IAM For ECS service
resource "aws_iam_role" "ecs_service_role" {
    name = "ecs_service_role"
    assume_role_policy = <<-JSON
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": "sts:AssumeRole",
          "Effect": "Allow",
          "Principal": {
            "Service": ["ecs.amazonaws.com", "ecs-tasks.amazonaws.com"]
          }
        }
      ]
    }
    JSON
}

# Attach IAM policy to ECS instance
resource "aws_iam_policy_attachment" "myapp1_ecs_instance_role_attach" {
    name = "${var.aws_resource_base_name}-ecs-instance-role-attach"
    roles = ["${aws_iam_role.ecs_instance_role.name}"]
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}


# Attach IAM policy to ECS service
resource "aws_iam_policy_attachment" "myapp1_ecs_service_role_attach" {
    name = "${var.aws_resource_base_name}-ecs-service-role-attach"
    roles = ["${aws_iam_role.ecs_service_role.name}"]
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
# Attach IAM policy to EC2 instance
resource "aws_iam_instance_profile" "myapp" {
    name = "${var.aws_resource_base_name}"
    role = "${aws_iam_role.ecs_instance_role.name}"
}

