output "alb_url" {
  description = "The URL of the Application Load Balancer"
  value       = aws_lb.app-lb.dns_name
}

output "alb_arn" {
  value = aws_lb.test.arn
}

output "target_group_arn" {
  value = aws_lb_target_group.test.arn
}

output "alb_listener" {
  value = aws_lb_listener.front_end.arn
}

output "alb_dns_name" {
  value = aws_lb.test.dns_name 
}

