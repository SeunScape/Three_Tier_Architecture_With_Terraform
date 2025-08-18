# Claude Code Assistant Guide

## Project Overview

This is a two-tier web application infrastructure managed with Terraform on AWS:
- **Web Tier**: EC2 instances serving a bash "Hello World" frontend via user data script
- **Data Tier**: MySQL RDS database
- **Access**: Users access the application through an Application Load Balancer (ALB) DNS name
- **Scalability**: EC2 Auto Scaling Group behind the ALB with target group configuration

## Repository Structure

```
.
├── modules/                 # Reusable Terraform modules
│   ├── services/            # Application services (separate state)
│   │   ├── alb/            # Application Load Balancer module
│   │   ├── asg/            # Auto Scaling Group module
│   │   ├── ec2/            # EC2 instance configuration
│   │   ├── vpc/            # VPC and networking
│   │   ├── security_group/ # Security groups
│   │   └── target_group/   # Target group configuration
│   └── database/           # Database tier (separate state)
│       ├── rds/            # RDS MySQL module
│       └── db_subnet_group/# Database subnet group
├── live/                   # Live environments
│   ├── prod/              # Production environment
│   │   ├── services/      # Service layer configuration
│   │   └── database/      # Database configuration
│   └── stage/             # Staging environment
│       ├── services/
│       └── database/
└── test_modules/          # Module testing (mirrors modules structure)
    ├── services/
    └── database/
```

## Module Organization Principles

### Critical Rules
1. **One AWS service per module** - Keep modules small and focused
2. **Separation of concerns** - Services and database use separate state files
3. **Module independence** - Each module must be self-contained with clear interfaces
4. **Consistent structure** - Every module must have:
   - `main.tf` - Resource definitions
   - `variables.tf` - Input variables
   - `outputs.tf` - Output values
   - `locals.tf` - Local values (if needed)

### State Management Strategy
- **Local state files** (since working independently)
- **Two separate states**:
  - Services state: `live/{environment}/services/terraform.tfstate`
  - Database state: `live/{environment}/database/terraform.tfstate`
- **IMPORTANT**: Database state is separate for safety and efficiency

## Naming Convention Standards

### Consistent Naming Pattern
All resources MUST use the project name variable for consistency:

```hcl
# Example in variables.tf
variable "project_name" {
  description = "Consistent project name used across all resources"
  type        = string
  default     = "myapp"  # Replace with your project name
}

variable "environment" {
  description = "Environment name (prod/stage)"
  type        = string
}
```

### Resource Naming Format
```hcl
# Pattern: {project_name}-{environment}-{service}-{resource_type}
# Examples:
name = "${var.project_name}-${var.environment}-web-alb"
name = "${var.project_name}-${var.environment}-app-asg"
name = "${var.project_name}-${var.environment}-db-mysql"
name = "${var.project_name}-${var.environment}-web-sg"
```

### Tag Standardization
```hcl
locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    Module      = path.module
  }
}
```

## Working with Terraform

### Essential Commands
```bash
terraform init

terraform fmt -recursive

terraform validate

terraform plan

terraform apply

terraform destroy
```

### Module Development Workflow
1. Create/modify module in `modules/` directory
2. Test module in `test_modules/` with minimal configuration
3. Integrate tested module into `live/stage/`
4. After validation, promote to `live/prod/`

## Module Interface Standards

### Services Modules

#### VPC Module (`modules/services/vpc/`)
```hcl
# Key outputs needed by other modules
output "vpc_id" {}
output "public_subnet_ids" {}
output "private_subnet_ids" {}
```

#### ALB Module (`modules/services/alb/`)
```hcl
# Required inputs
variable "vpc_id" {}
variable "subnet_ids" {}
variable "security_group_id" {}

# Key outputs
output "alb_dns_name" {}
output "alb_arn" {}
output "alb_zone_id" {}
```

#### ASG Module (`modules/services/asg/`)
```hcl
# Required inputs
variable "subnet_ids" {}
variable "target_group_arns" {}
variable "user_data_script" {}
variable "security_group_id" {}

# Configuration
variable "min_size" { default = 1 }
variable "max_size" { default = 3 }
variable "desired_capacity" { default = 2 }
```

### Database Modules

#### RDS Module (`modules/database/rds/`)
```hcl
# Required inputs
variable "subnet_ids" {}
variable "security_group_id" {}
variable "db_name" {}
variable "db_username" {}
variable "db_password" {}  # Use AWS Secrets Manager in production

# Key outputs
output "db_endpoint" {}
output "db_port" {}
```

## EC2 User Data Script

### Location and Management
The bash "Hello World" script should be:
1. Stored as a template file: `modules/services/asg/templates/user_data.sh.tpl`
2. Passed as a variable to the ASG module
3. Templated for environment-specific values

Example structure:
```bash
#!/bin/bash
# user_data.sh.tpl
cat > /var/www/html/index.html <<EOF
<html>
<h1>Hello World from ${environment}</h1>
<p>Project: ${project_name}</p>
</html>
EOF
```

## Security Guidelines

### Security Groups
- **ALB Security Group**: Allow HTTP/HTTPS from internet (0.0.0.0/0)
- **EC2 Security Group**: Allow traffic only from ALB security group
- **RDS Security Group**: Allow MySQL port (3306) only from EC2 security group

### Best Practices
- ✅ Use security group references instead of CIDR blocks where possible
- ✅ Enable RDS encryption at rest
- ✅ Use HTTPS listeners on ALB (with ACM certificate)
- ✅ Enable access logs for ALB
- ✅ Use IAM instance profiles for EC2 instances

## Environment-Specific Configurations

### Stage Environment (`live/stage/`)
- Smaller instance types (t3.micro/t3.small)
- Minimal ASG capacity (min: 1, max: 2)
- Single-AZ RDS instance (cost optimization)
- Relaxed backup requirements

### Production Environment (`live/prod/`)
- Larger instance types (t3.medium or larger)
- Higher ASG capacity (min: 2, max: 5+)
- Multi-AZ RDS deployment
- Automated backups with 7-30 day retention
- Enable deletion protection on RDS

## AI Assistant Instructions

When working in this repository:

### Module Creation/Modification
1. **Maintain module isolation** - Each AWS service gets its own module
2. **Use consistent variable names** - Always use `project_name` and `environment`
3. **Follow the naming pattern** - `${var.project_name}-${var.environment}-{service}-{type}`
4. **Respect state separation** - Never mix database and service resources in the same state

### Code Standards
1. **Always use data sources** for existing resources instead of hardcoding
2. **Parameterize everything** - No hardcoded values except defaults
3. **Output essential values** - Each module must output values needed by other modules
4. **Comment complex logic** - Explain any non-obvious configurations

### Testing Approach
1. **Test in `test_modules/` first** - Create minimal test configurations
2. **Validate in stage** - Always test in stage before production
3. **Check dependencies** - Ensure module outputs align with other module inputs

### Common Patterns to Follow
```hcl
# Use locals for repeated values
locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

# Use try() for optional variables
resource "aws_instance" "example" {
  monitoring = try(var.enable_monitoring, false)
}

# Use for_each for multiple similar resources
resource "aws_security_group_rule" "ingress" {
  for_each = var.ingress_rules
  # ...
}
```

### Never Do This
- ❌ Hardcode project names or environments
- ❌ Mix database and service resources in the same module
- ❌ Create circular dependencies between modules
- ❌ Ignore the established naming convention
- ❌ Commit terraform.tfstate files (add to .gitignore)

## Module Dependencies Flow

```
VPC Module
    ↓
Security Groups Module
    ↓
    ├── ALB Module
    │   ↓
    │   Target Group Module
    │   ↓
    │   ASG Module (EC2 instances)
    │
    └── RDS Module (separate state)
```

## Troubleshooting

### Common Issues

1. **Circular Dependency Error**
   - Check module outputs and inputs
   - Ensure proper dependency flow

2. **State Lock Issues (if using remote state later)**
   - Check for uncommitted changes
   - Manually unlock if necessary

3. **ASG Not Registering with Target Group**
   - Verify security group rules
   - Check health check configuration
   - Ensure user data script completes successfully

## Quick Reference

### Required Variables in Each Module
```hcl
variable "project_name" {
  description = "Project name for consistent naming"
  type        = string
}

variable "environment" {
  description = "Environment (prod/stage)"
  type        = string
}

variable "tags" {
  description = "Additional tags to apply"
  type        = map(string)
  default     = {}
}
```

### Output Naming Convention
- VPC outputs: `vpc_*`
- Subnet outputs: `subnet_*`
- Security group outputs: `sg_*`
- Database outputs: `db_*`
- Load balancer outputs: `alb_*`

---

**Remember**: Maintain strict module separation and consistent naming. Every change should follow the established patterns to ensure reusability and maintainability.