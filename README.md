# Two-Tier Web Application with Terraform

A scalable two-tier web application infrastructure deployed on AWS using Terraform. Features an Auto Scaling web tier serving a "Hello World" application with MySQL RDS backend, accessed through an Application Load Balancer.

## Architecture

**Web Tier:**
- EC2 instances in Auto Scaling Group behind Application Load Balancer
- Bash "Hello World" frontend served via user data script
- Target group configuration for health checks

**Data Tier:**
- MySQL RDS database with subnet groups
- Isolated in private subnets for security

**Access:**
- Users access the application through ALB DNS name
- Security groups control traffic flow between tiers

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.0
- [AWS CLI](https://aws.amazon.com/cli/) configured with appropriate credentials
- AWS account with sufficient permissions for EC2, RDS, VPC, and Load Balancer resources

## Project Structure

```
.
├── modules/                    # Reusable Terraform modules
│   ├── services/              # Application services (separate state)
│   │   └── webserver-cluster/ # Web tier with ALB, ASG, EC2, VPC, security groups
│   └── data-storage/          # Database tier (separate state)
│       └── mysql/             # RDS MySQL module
├── prod/                      # Production environment
│   ├── webserver-cluster/     # Production web services
│   └── data-storage/          # Production database
└── stage/                     # Staging environment
    ├── webserver-cluster/     # Staging web services
    └── data-storage/          # Staging database
```

## Quick Start

### 1. Clone and Configure
```bash
git clone <repository-url>
cd Two-tier-Application-With-Terraform

# Configure AWS credentials
aws configure
```

### 2. Deploy to Staging
```bash
# Deploy database first
cd stage/data-storage
terraform init
terraform plan
terraform apply

# Deploy web services
cd ../webserver-cluster
terraform init
terraform plan
terraform apply
```

### 3. Access Application
After deployment, get the ALB DNS name:
```bash
terraform output alb_dns_name
```
Access your application at: `http://<alb-dns-name>`

## Available Environments

### Staging (`stage/`)
- **Purpose:** Testing and validation
- **Instance Types:** t3.micro/t3.small (cost optimized)
- **ASG Capacity:** Min: 1, Max: 2
- **RDS:** Single-AZ deployment
- **Use Case:** Development testing, feature validation

### Production (`prod/`)
- **Purpose:** Live application
- **Instance Types:** t3.medium or larger
- **ASG Capacity:** Min: 2, Max: 5+
- **RDS:** Multi-AZ deployment with automated backups
- **Use Case:** Production workloads

## Key Features

- **Separation of Concerns:** Database and services use separate Terraform state files
- **Auto Scaling:** Web tier automatically scales based on demand
- **High Availability:** Multi-AZ deployment options in production
- **Security:** Security groups restrict traffic between tiers
- **Consistent Naming:** All resources follow `{project}-{environment}-{service}-{type}` convention

## Commands Reference

```bash
# Format Terraform files
terraform fmt -recursive

# Validate configuration
terraform validate

# Plan changes
terraform plan

# Apply changes
terraform apply

# Destroy infrastructure (use with caution)
terraform destroy
```

## Security Considerations

- ALB accepts HTTP/HTTPS traffic from internet
- EC2 instances only accept traffic from ALB security group
- RDS only accepts connections from EC2 security group on port 3306
- All resources use consistent tagging for management

## Troubleshooting

**ASG instances not registering with target group:**
- Check security group rules allow traffic from ALB to EC2
- Verify health check configuration in target group
- Ensure user data script completes successfully

**Cannot connect to RDS:**
- Verify security group allows connections from EC2 on port 3306
- Check subnet group configuration
- Ensure RDS is in private subnets

---

**⚠️ Important:** Always test changes in staging before applying to production. Use `terraform plan` to review changes before applying.
