# ALB Security Group

resource "aws_security_group" "alb_sg" {
    name        = "${var.project_name} -alb-sg"
    description = "security group for ALB"
    vpc_id      = var.vpc_id

    ingress {
        from_port = 80
        to_port   = 80
        protocol  = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port   = 0
        protocol  = -1
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${var.project_name}-alb-sg"
    }
}

# APPLICATION LOAD BALANCER

resource "aws_lb" "main" {
    name               = "${var.project_name}-alb"
    internal           = false
    load_balancer_type = "application"
    security_groups    = [aws_security_group.alb_sg.id]
    subnets            = [var.public_subnet_1_id, var.public_subnet_2_id]

    tags = {
        Name = "${var.project_name}-alb"
    }
}

# Target Groups 

resource "aws_lb_target_group" "main" {
    name     = "${var.project_name}-tg"
    port     = 80
    protocol = "HTTP"
    vpc_id   = var.vpc_id

    health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    path                = "/"
    matcher             = "200"
    }

    tags = {
        Name = "${var.project_name}-tg"
    }
}

# Listener

resource  "aws_lb_listener" "main" {
    load_balancer_arn = aws_lb.main.arn
    port              = 80
    protocol          = "HTTP"

    default_action{
        type             = "forward"
        target_group_arn = aws_lb_target_group.main.arn
    }
}




