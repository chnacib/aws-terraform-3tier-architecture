resource "aws_lb" "load_balancer" {
  name                       = "load-balancer"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.sg_lb.id, aws_security_group.default.id]
  subnets                    = [aws_subnet.public_subnet1.id, aws_subnet.public_subnet2.id]
  enable_deletion_protection = false
}

resource "aws_lb_target_group" "target_group" {
  name        = "load-balancer-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main_vpc.id
  target_type = "instance"


  #target_id = aws_instance.ec2_private_1.id
}

resource "aws_lb_target_group_attachment" "tg_attach1" {
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id        = aws_instance.ec2_private_1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "tg_attach2" {
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id        = aws_instance.ec2_private_2.id
  port             = 80
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }




}