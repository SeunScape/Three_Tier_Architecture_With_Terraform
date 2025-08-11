provider "aws" {
    region = "us-east-2"
}


resource "aws_launch_template" "config" {
    name_prefix   = "${var.cluster_name}-lt-"
    image_id      = "ami-0fb653ca2d3203ac1"
    instance_type = "${var.instance_type}"

    vpc_security_group_ids = [aws_security_group.instance-sg.id]

    user_data = base64encode(templatefile("user-data.sh", {
        server_port = var.port_number
        db_address  = data.terraform_remote_state.db.outputs.db_address
        db_port     = data.terraform_remote_state.db.outputs.db_port
    }))

    lifecycle {
        create_before_destroy = true
    }

    tag_specifications {
        resource_type = "instance"
        tags = {
            Name = "${var.cluster_name}-instance"
        }
    }
}

resource "aws_security_group" "instance-sg"{
    name = "${var.cluster_name}-instance-sg"
    ingress {
        from_port = var.port_number
        to_port = var.port_number
        protocol = "tcp"
        cidr_blocks = local.all_ips 
    }

      egress {
        from_port = local.any_port
        to_port = local.any_port
        protocol = local.any_protocol
        cidr_blocks = local.all_ips 
    }
}


data "aws_vpc" "default" {
default = true
}

data "aws_subnets" "default"{
    filter {
        name = "vpc-id"
        values = [data.aws_vpc.default.id]
    }
}
resource "aws_security_group" "alb-sg" {
    name = "${var.cluster_name}-alb-sg"

    ingress {
       from_port = local.http_port
       to_port = local.http_port
       protocol = local.tcp_protocol
       cidr_blocks = local.all_ips 
    }

    egress {
       from_port = local.any_port
       to_port = local.any_port
       protocol = local.any_protocol
       cidr_blocks = local.all_ips 
    }
}

resource "aws_lb" "instance-lb" {
    name = "${var.cluster_name}-instances-lb"
    load_balancer_type = "application"
    subnets = data.aws_subnets.default.ids
    security_groups = [aws_security_group.alb-sg.id]
}

resource "aws_lb_listener" "http" {
    load_balancer_arn = aws_lb.instance-lb.arn
    port = local.http_port
    protocol = "HTTP"

    default_action {
        type = "fixed-response"
     
        fixed_response {
            content_type = "text/plain"
            message_body = "404: page not found"
            status_code = 404
        }
    }

}

resource "aws_lb_target_group" "instance-targets"{
    name = "${var.cluster_name}-instance-targets"
    port = var.port_number
    protocol = "HTTP"
    vpc_id= data.aws_vpc.default.id

    health_check {
        path= "/"
        protocol = "HTTP"
        matcher = "200"
        interval = 15
        timeout = 3
        healthy_threshold = 2
        unhealthy_threshold = 2
}
}
resource "aws_lb_listener_rule" "asg" {
    listener_arn = aws_lb_listener.http.arn
    priority = 100
   
    condition {
        path_pattern {
            values = ["*"]
        }
    }
    action {
        type = "forward"
        target_group_arn = aws_lb_target_group.instance-targets.arn
    }
}
resource "aws_autoscaling_group" "asg"{
    launch_template {
        id = aws_launch_template.config.id
        version = "$Latest"
    }
    max_size = 3
    min_size = 2 
    vpc_zone_identifier = data.aws_subnets.default.ids

    target_group_arns = [aws_lb_target_group.instance-targets.arn]
    health_check_type = "ELB"

    tag {
        key = "Name"
        value = "${var.cluster_name}-asg"
        propagate_at_launch = true
    }
}

data "terraform_remote_state" "db" {
    backend = "local"
    config = {
    path = "../data-storage/mysql/terraform.tfstate"
  }
}