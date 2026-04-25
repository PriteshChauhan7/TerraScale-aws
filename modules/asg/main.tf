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

# Get instance metadata using IMDSv2
TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
INSTANCE_ID=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id)
AZ=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/placement/availability-zone)
INSTANCE_TYPE=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-type)

cat > /var/www/html/index.html << HTML
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TerraScale - Production Infrastructure</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', sans-serif;
            background: #0a0e1a;
            color: #e0e0e0;
            min-height: 100vh;
        }
        header {
            background: linear-gradient(135deg, #1a1f35, #0d1b2a);
            padding: 20px 40px;
            border-bottom: 2px solid #FF9900;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .logo {
            font-size: 28px;
            font-weight: bold;
            color: #FF9900;
        }
        .logo span { color: #ffffff; }
        .status-badge {
            background: #00c853;
            color: white;
            padding: 6px 16px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: bold;
        }
        .hero {
            text-align: center;
            padding: 60px 20px 40px;
            background: linear-gradient(180deg, #0d1b2a, #0a0e1a);
        }
        .hero h1 {
            font-size: 48px;
            color: #FF9900;
            margin-bottom: 16px;
        }
        .hero p {
            font-size: 18px;
            color: #9e9e9e;
            max-width: 600px;
            margin: 0 auto;
        }
        .container {
            max-width: 1100px;
            margin: 0 auto;
            padding: 40px 20px;
        }
        .cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
        }
        .card {
            background: #1a1f35;
            border: 1px solid #2a3050;
            border-radius: 12px;
            padding: 24px;
            transition: transform 0.2s;
        }
        .card:hover { transform: translateY(-4px); }
        .card-icon {
            font-size: 32px;
            margin-bottom: 12px;
        }
        .card-label {
            font-size: 12px;
            color: #9e9e9e;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 8px;
        }
        .card-value {
            font-size: 18px;
            font-weight: bold;
            color: #FF9900;
            word-break: break-all;
        }
        .architecture {
            background: #1a1f35;
            border: 1px solid #2a3050;
            border-radius: 12px;
            padding: 30px;
            margin-bottom: 40px;
        }
        .architecture h2 {
            color: #FF9900;
            margin-bottom: 20px;
            font-size: 22px;
        }
        .arch-flow {
            display: flex;
            align-items: center;
            justify-content: center;
            flex-wrap: wrap;
            gap: 10px;
        }
        .arch-item {
            background: #0a0e1a;
            border: 1px solid #FF9900;
            border-radius: 8px;
            padding: 10px 16px;
            font-size: 13px;
            color: #FF9900;
            text-align: center;
        }
        .arch-arrow {
            color: #FF9900;
            font-size: 20px;
        }
        .badges {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            justify-content: center;
            margin-bottom: 40px;
        }
        .badge {
            background: #1a1f35;
            border: 1px solid #2a3050;
            border-radius: 20px;
            padding: 8px 16px;
            font-size: 13px;
            color: #e0e0e0;
        }
        .badge span { color: #FF9900; }
        .refresh-note {
            text-align: center;
            background: #1a1f35;
            border: 1px solid #FF9900;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 40px;
        }
        .refresh-note p {
            color: #9e9e9e;
            font-size: 14px;
        }
        .refresh-note strong { color: #FF9900; }
        footer {
            text-align: center;
            padding: 20px;
            border-top: 1px solid #2a3050;
            color: #9e9e9e;
            font-size: 13px;
        }
    </style>
</head>
<body>
    <header>
        <div class="logo">Terra<span>Scale</span></div>
        <div class="status-badge">● LIVE</div>
    </header>

    <div class="hero">
        <h1>TerraScale - Cloud Infrastructure Platform</h1>
        <p>Production-grade 3-tier AWS architecture deployed with Terraform and GitHub Actions CI/CD</p>
    </div>

    <div class="container">

        <div class="cards">
            <div class="card">
                <div class="card-icon">🖥️</div>
                <div class="card-label">Instance ID</div>
                <div class="card-value">$INSTANCE_ID</div>
            </div>
            <div class="card">
                <div class="card-icon">🌍</div>
                <div class="card-label">Availability Zone</div>
                <div class="card-value">$AZ</div>
            </div>
            <div class="card">
                <div class="card-icon">⚡</div>
                <div class="card-label">Instance Type</div>
                <div class="card-value">$INSTANCE_TYPE</div>
            </div>
            <div class="card">
                <div class="card-icon">🔄</div>
                <div class="card-label">Load Balancer</div>
                <div class="card-value">Active & Healthy</div>
            </div>
        </div>

        <div class="refresh-note">
            <p>💡 <strong>Tip:</strong> Refresh this page to see load balancing in action! The Instance ID will change as ALB routes requests to different EC2 instances.</p>
        </div>

        <div class="architecture">
            <h2>🏗️ Architecture Overview</h2>
            <div class="arch-flow">
                <div class="arch-item">🌐 Internet</div>
                <div class="arch-arrow">→</div>
                <div class="arch-item">⚖️ ALB</div>
                <div class="arch-arrow">→</div>
                <div class="arch-item">🖥️ EC2 (ASG)</div>
                <div class="arch-arrow">→</div>
                <div class="arch-item">🗄️ RDS MySQL</div>
            </div>
        </div>

        <div class="badges">
            <div class="badge">🏗️ <span>Terraform</span> Modules</div>
            <div class="badge">☁️ <span>AWS</span> us-east-1</div>
            <div class="badge">🔄 <span>Auto Scaling</span> Group</div>
            <div class="badge">⚖️ <span>Application</span> Load Balancer</div>
            <div class="badge">🗄️ <span>RDS</span> MySQL 8.0</div>
            <div class="badge">🔒 <span>Private</span> Subnets</div>
            <div class="badge">📊 <span>CloudWatch</span> Monitoring</div>
            <div class="badge">🚀 <span>GitHub Actions</span> CI/CD</div>
            <div class="badge">🪣 <span>S3</span> Remote State</div>
        </div>

    </div>

    <footer>
        <p>Built by Pritesh | Powered by AWS + Terraform + GitHub Actions</p>
    </footer>
</body>
</html>
HTML
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
  



