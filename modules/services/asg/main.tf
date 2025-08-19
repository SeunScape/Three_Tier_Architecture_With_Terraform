locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

variable "key_pair_name" {
  description = "AWS EC2 Key Pair name for SSH access"
  type        = string
  default     = "terraform-web-key"
}

resource "aws_launch_template" "main" {
  name_prefix   = "${local.name_prefix}-lt-"
  image_id      = var.ami_id
  instance_type = var.instance_type

  key_name = var.key_pair_name

  vpc_security_group_ids = [var.security_group_id]

  user_data = base64encode(templatefile("${path.module}/templates/user_data.sh.tpl", {
    server_port  = var.server_port
    environment  = var.environment
    project_name = var.project_name
    db_address   = var.db_address
    db_port      = var.db_port
  }))

  lifecycle {
    create_before_destroy = true
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${local.name_prefix}-instance"
    }
  }
}

resource "aws_autoscaling_group" "main" {
  launch_template {
    id      = aws_launch_template.main.id
    version = "$Latest"
  }
  
  max_size            = var.max_size
  min_size            = var.min_size
  desired_capacity    = var.desired_capacity
  vpc_zone_identifier = var.subnet_ids

  target_group_arns   = var.target_group_arns
  health_check_type   = "ELB"

  tag {
    key                 = "Name"
    value               = "${local.name_prefix}-asg"
    propagate_at_launch = true
  }
}