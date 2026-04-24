output "asg_name" {
    description = " name for autoscaling group"
    value = aws_autoscaling_group.main.name
}

output "ec2_sg_id" {
    description = "security froup id of ec2"
    value = aws_security_group.ec2_sg.id
}

