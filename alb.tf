# ALudo
resource "aws_alb" "myapp" {
  name            = "${var.aws_resource_base_name}"
  security_groups = ["${aws_security_group.myapp.id}"]
  subnets         = ["${aws_subnet.myapp_public_a.id}", "${aws_subnet.myapp_public_c.id}"]
}

# ALB Listner
resource "aws_alb_listener" "myapp" {
  load_balancer_arn = "${aws_alb.myapp.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.myapp.id}"
    type             = "forward"
  }
}

# ALB Target
resource "aws_alb_target_group" "myapp" {
  name_prefix     = "myapp"
  protocol = "HTTP"
  port     = 7777
  target_type = "ip"
  vpc_id   = "${aws_vpc.myapp.id}"

  deregistration_delay = 10

  lifecycle {
    create_before_destroy = true
  }

  health_check {
    path                = "/"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = "200"
  }

  stickiness {
    enabled = false
    type = "lb_cookie"
  }
}
       
