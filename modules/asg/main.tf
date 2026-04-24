# Security group for EC2

resource "aws_security_group" "ec2_sg" {
    name = "${var.project_name} - ec2-sg"
    description = "security group for ec2"
    vpc_id = var.vpc_id

    ingress{
        from_port = 80
        to_port   = 80
        protocol  = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress{ 
        from_port = 22
        to_port   = 22
        protocol  = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port   = 0
        protocol  = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name ="${var.project_name} -ec2-sg"
    }
}

# Launch Template

resource "aws_launch_template" "main" {
    name_prefix = "${var.project_name}-lt"
    image_id = var.ami_id
    instance_type = var.instance_type

    network_interfaces {
      associate_public_ip_address = true
      security_groups = [aws_security_group.ec2_sg.id]
    }

    user_data = base64encode(<<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    echo "<h1>Welcome to TerraScale! Instance ID: $(curl -s http://169.254.169.254/latest/meta-data/instance-id)</h1>" > /var/www/html/index.html
  EOF
  )

  tags = {
    Name = "${var.project_name}-lt"
  }
}

# Auto Scaling Group

resource "aws_autoscaling_group" "main" {
    name                = "${var.project_name}-asg"
    vpc_zone_identifier = [var.public_subnet_1_id, var.public_subnet_2_id]
    target_group_arns   = [var.target_group_arn]
    health_check_type   = "ELB"
    min_size            = var.min_size
    max_size            = var.max_size
    desired_capacity    = var.desired_capacity
    
    launch_template {
    id      = aws_launch_template.main.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.project_name}-ec2"
    propagate_at_launch = true
  }
}
  



