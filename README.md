# Terraform-Ansible AWS Infrastructure

A production-ready, two-tier web application infrastructure built with Terraform and configured with Ansible, demonstrating DevOps best practices and infrastructure as code principles. This project was inspired by concepts from "Terraform: Up and Running" by Yevgeniy Brikman.

## 🏗️ Project Overview

This project implements a scalable web application infrastructure on AWS using:
- **Terraform** for infrastructure provisioning (IaC)
- **Ansible** for configuration management
- **AWS** services including EC2, RDS, ALB, and Auto Scaling

The infrastructure serves a web application with automated scaling, load balancing, and zero-downtime deployments across staging and production environments.

## 📐 Architecture

```
Internet
    |
    ↓
Application Load Balancer (ALB)
    |
    ↓
Target Group
    |
    ↓
Auto Scaling Group (ASG)
    |
    ├── EC2 Instance 1 (Nginx)
    ├── EC2 Instance 2 (Nginx)
    └── EC2 Instance N (Nginx)
            |
            ↓
        RDS MySQL Database
```

### Component Interactions

1. **User Traffic**: Users access the application through the ALB's DNS name
2. **Load Distribution**: ALB distributes requests across healthy EC2 instances
3. **Auto Scaling**: ASG maintains desired capacity and replaces unhealthy instances
4. **Web Servers**: EC2 instances run Nginx (installed via Ansible) serving an HTML page that displays RDS connection details
5. **Database**: MySQL RDS instance (currently commented out but fully configured)

## 🛠️ Terraform Implementation

### Module Architecture

The project follows DRY principles through reusable Terraform modules.

Each module has defined inputs (`variables.tf`) and outputs (`outputs.tf`) for reusability across environments.

### State Management

Implemented isolated state management with separate states for services and database layers, improving security and reducing blast radius.

### Environment Configurations

- **Staging** (`stage/`): Smaller instances (t3.micro), reduced capacity for testing
- **Production** (`prod/`): Larger instances (m4.large), higher capacity, Multi-AZ RDS

## 🔧 Ansible Configuration Management

### Dynamic Inventory

Ansible automatically discovers EC2 instances using AWS API, filtering by instance tags and state. No manual IP management required.

### Configuration Workflow

1. Terraform provisions EC2 instances with basic busybox web server
2. Ansible playbook installs and configures Nginx
3. Jinja2 templates deploy environment-specific configurations
4. Health checks validate deployment

## 🚀 Zero-Downtime Deployment

Production implements zero-downtime deployments through:

1. **Rolling Updates**: Launch template versioning with gradual instance replacement
2. **Health Checks**: New instances must pass ELB health checks before receiving traffic
3. **Connection Draining**: Graceful termination of old instances

## 🔐 Security Implementation

- **Layered Security Groups**: 
  - ALB allows HTTP from internet
  - EC2 allows traffic only from ALB
  - RDS allows MySQL only from EC2
- **Key-based SSH authentication**
- **IAM roles for AWS service access**

## 📁 Project Structure

```
.
├── modules/                     # Reusable Terraform modules
│   ├── services/
│   │   └── webserver-cluster/
│   └── data-storage/
│       └── mysql/
├── stage/                       # Staging environment
├── prod/                        # Production environment
├── ansible/                     # Ansible configuration
│   ├── playbooks/
│   ├── inventory/
│   └── templates/
└── README.md
```

## 🔄 Future Enhancements

- [ ] CI/CD pipeline with GitHub Actions
- [ ] Terraform remote state with S3 backend and state locking
- [ ] CloudWatch monitoring and alerting

---