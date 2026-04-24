output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "alb_dns_name" {
  description = "DNS name of ALB - use this to access website"
  value       = module.alb.alb_dns_name
}

output "rds_endpoint" {
  description = "Endpoint of RDS database"
  value       = module.rds.rds_endpoint
}

output "sns_topic_arn" {
  description = "ARN of SNS alerts topic"
  value       = module.monitoring.sns_topic_arn
}