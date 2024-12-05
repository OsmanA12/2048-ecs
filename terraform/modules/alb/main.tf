# ALB


resource "aws_lb" "test" {
 name               = "2048-alb"
 internal           = false
 load_balancer_type = "application"
 security_groups    = [var.security_group_id]
 subnets            = var.subnet_ids 
 enable_deletion_protection = true




 tags = {
   Environment = "production"
 }
}


# Target group ALB


resource "aws_lb_target_group" "test" {
 name     = "2048-tg"
 port     = 3000
 protocol = "HTTP"
 vpc_id   = var.vpc_id
 target_type = "ip" 
}




resource "aws_lb_target_group" "alb-example" {
 name        = "208-tg1"
 target_type = "alb"
 port        = 80
 protocol    = "TCP"
 vpc_id      = aws_vpc.main.id
}


#ALB listener HTTP
resource "aws_lb_listener" "front_end" {
 load_balancer_arn = aws_lb.test.arn
 port              = "80"
 protocol          = "HTTP"




 default_action {
   type             = "redirect"
   target_group_arn = aws_lb_target_group.test.arn
  redirect {
     port        = "443"
     protocol    = "HTTPS"
     status_code = "HTTP_301"
   }
 }
}