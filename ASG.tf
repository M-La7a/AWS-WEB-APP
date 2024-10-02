# Create Auto Scaling Group
resource "aws_autoscaling_group" "web" {
 name = "ASG"
 launch_configuration = aws_launch_configuration.web.id
 min_size = 1
 max_size = 3
 desired_capacity = 2
 vpc_zone_identifier = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
 target_group_arns = [aws_lb_target_group.app_tg.arn]
 tag {
 key = "Name"
 value = "ASG_Instance"
 propagate_at_launch = true
 }
}

# Create Application Load Balancer
resource "aws_lb" "app_lb" {
  name               = "app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public_subnet_1.id,aws_subnet.public_subnet_2.id]

  enable_deletion_protection = false
  tags = {
    Name = "AppLB"
  }
}

# Create Target Group
resource "aws_lb_target_group" "app_tg" {
  name        = "app-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main_vpc.id
  target_type = "instance"


  tags = {
    Name = "AppTG"
  }
}

# Attach EC2 instance to the Target Group
/*resource "aws_lb_target_group_attachment" "web_instance" {
  target_group_arn = aws_lb_target_group.app_tg.arn
  target_id        = aws_launch_configuration.web.id
  port             = 80
}*/

# Create Listener for the ALB
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}