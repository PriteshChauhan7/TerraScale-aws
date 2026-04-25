# TerraScale

A 3-tier AWS infrastructure project built with Terraform. This project provisions a complete cloud environment including networking, compute, database, and monitoring — all automated through a CI/CD pipeline.

**Live:** http://terrascale-alb-1956354960.us-east-1.elb.amazonaws.com

> Refresh the page a few times — you'll notice the Instance ID changing. That's the load balancer routing requests to different EC2 instances.

---

## What's in this project

- Custom VPC with public and private subnets across 2 availability zones
- Application Load Balancer with health checks
- Auto Scaling Group that scales EC2 instances based on CPU
- RDS MySQL database in a private subnet
- CloudWatch alarms with SNS email notifications
- Terraform remote state stored in S3 with DynamoDB locking
- GitHub Actions pipeline that runs `terraform apply` on every push

---

## Architecture
Internet → ALB → EC2 (Auto Scaling Group) → RDS MySQL
|
CloudWatch + SNS
---

## Project Structure

terrascale-aws/
modules/
vpc/
alb/
asg/
rds/
monitoring/
main.tf
variables.tf
outputs.tf
.github/
workflows/
deploy.yml
---

## Tech Stack

- **Terraform** — Infrastructure as Code
- **AWS** — VPC, EC2, ALB, ASG, RDS, CloudWatch, SNS, S3
- **GitHub Actions** — CI/CD

---

## Deployment

Add these secrets to your GitHub repository:
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_REGION
AMI_ID
DB_PASSWORD
ALERT_EMAIL
Then just push to main:

```bash
git push origin main
```

GitHub Actions handles the rest.

---

## Security notes

- RDS is in a private subnet with no internet access
- EC2 instances only accept traffic from the ALB
- Database only accepts connections from EC2 instances
- Secrets are stored in GitHub Secrets, not in code

---

## Author

Pritesh Chauhan
- AWS Solutions Architect Associate
- Red Hat Certified System Administrator
- GitHub: [PriteshChauhan7](https://github.com/PriteshChauhan7)
