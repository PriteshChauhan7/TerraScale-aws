# 🚀 TerraScale — Production AWS Infrastructure

A production-grade 3-tier AWS infrastructure built with Terraform modules and automated CI/CD using GitHub Actions.

## 🌐 Live Demo
[Click here to view live](http://terrascale-alb-1956354960.us-east-1.elb.amazonaws.com)

> 💡 Refresh the page to see load balancing in action — Instance ID changes as ALB routes to different EC2s!

---

## 🏗️ Architecture
Internet → ALB → Auto Scaling Group (EC2) → RDS MySQL
↓
CloudWatch + SNS Alerts
---

## ✅ Features

- **VPC** with public and private subnets across 2 Availability Zones
- **Application Load Balancer** distributing traffic across EC2 instances
- **Auto Scaling Group** automatically scaling based on CPU usage
- **RDS MySQL** in private subnet — not accessible from internet
- **CloudWatch Alarms** monitoring CPU and ALB request count
- **SNS Notifications** sending email alerts when thresholds breached
- **Remote State** stored in S3 with DynamoDB state locking
- **GitHub Actions CI/CD** automatically deploying on every push to main

---

## 🛠️ Tech Stack

| Technology | Usage |
|------------|-------|
| Terraform | Infrastructure as Code |
| AWS VPC | Networking |
| AWS ALB | Load Balancing |
| AWS EC2 + ASG | Compute + Auto Scaling |
| AWS RDS MySQL 8.0 | Database |
| AWS CloudWatch | Monitoring |
| AWS SNS | Alerting |
| AWS S3 + DynamoDB | Remote State + Locking |
| GitHub Actions | CI/CD Pipeline |

---

## 📁 Project Structure
terrascale-aws/
modules/
vpc/          → VPC, Subnets, IGW, NAT Gateway, Route Tables
alb/          → ALB, Target Group, Listener, Security Group
asg/          → Launch Template, Auto Scaling Group, Security Group
rds/          → RDS MySQL, DB Subnet Group, Security Group
monitoring/   → CloudWatch Alarms, SNS Topic, SNS Subscription
main.tf              → Root module connecting all modules
variables.tf         → Input variable declarations
outputs.tf           → Output values
terraform.tfvars     → Variable values
.github/
workflows/
deploy.yml       → GitHub Actions CI/CD pipeline

---

## 🔄 CI/CD Pipeline

Every push to main branch automatically:
git push origin main
↓
GitHub Actions triggers
↓
Installs Terraform on Ubuntu VM
↓
Configures AWS credentials
↓
terraform init → terraform plan → terraform apply
↓
Infrastructure updated on AWS automatically!

---

## 🚀 How to Deploy

**Prerequisites:**
- AWS Account with IAM credentials
- Terraform installed locally
- GitHub repository with secrets configured

**Required GitHub Secrets:**
AWS_ACCESS_KEY_ID      → AWS access key
AWS_SECRET_ACCESS_KEY  → AWS secret key
AWS_REGION             → us-east-1
AMI_ID                 → Amazon Linux 2023 AMI
DB_PASSWORD            → RDS MySQL password
ALERT_EMAIL            → Email for CloudWatch alerts

**Deploy automatically:**
```bash
git push origin main
# GitHub Actions runs terraform apply automatically!
```

**Deploy locally:**
```bash
terraform init
terraform plan
terraform apply
```

**Destroy:**
```bash
terraform destroy
```

---

## 🔒 Security Best Practices

- RDS MySQL in **private subnet** — never exposed to internet
- EC2 instances only accept traffic **from ALB** — not directly from internet
- Database only accepts connections **from EC2 security group**
- Terraform state **encrypted** in S3 bucket
- **DynamoDB locking** prevents concurrent state modifications
- Sensitive values stored in **GitHub Secrets** — never in code

---

## 📊 Monitoring & Alerting

| Alarm | Threshold | Action |
|-------|-----------|--------|
| High CPU | > 70% for 2 periods | Email alert via SNS |
| High Traffic | > 1000 requests/min | Email alert via SNS |

- Auto Scaling automatically adds EC2 instances under high load
- Auto Scaling removes EC2 instances when load decreases
- Saves cost during low traffic periods

---

## 🌐 Network Architecture
VPC (10.0.0.0/16)
├── Public Subnet 1 (10.0.1.0/24) — us-east-1a
│     └── ALB + EC2 (Web Servers)
├── Public Subnet 2 (10.0.2.0/24) — us-east-1b
│     └── ALB + EC2 (Web Servers)
├── Private Subnet 1 (10.0.3.0/24) — us-east-1a
│     └── RDS MySQL
└── Private Subnet 2 (10.0.4.0/24) — us-east-1b
└── RDS MySQL (Standby)
---

## 👨‍💻 Author

**Pritesh Chauhan**
- 🏆 AWS Solutions Architect Associate (SAA-C03)
- 🏆 Red Hat Certified System Administrator (RHCSA)
- 💼 GitHub: [PriteshChauhan7](https://github.com/PriteshChauhan7)

---

## ⚠️ Cost Warning

NAT Gateway (~$0.045/hr) and RDS (~$0.02/hr) incur charges.
Run `terraform destroy` when not needed to avoid unnecessary costs.
