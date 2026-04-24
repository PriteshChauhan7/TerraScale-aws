output "alb_arn"{
    description = "Amazon resource name of ALB"
    value       = aws_lb.main.arn
}

output "alb_dns_name" {
    description = "DNS name of ALB"
    value       = aws_lb.main.dns_name
}

output "target_group_arn" { 
    description = "ARN of target group"
    value       = aws_lb_target_group.main.arn 
}