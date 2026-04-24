variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "asg_name" {
  description = "Name of Auto Scaling Group"
  type        = string
}

variable "alb_arn" {
  description = "ARN of the ALB"
  type        = string
}

variable "alert_email" {
  description = "Email address for alerts"
  type        = string
}