variable "port_number" {
    type = number
    default = 8080
    description = "desctiption for this variable"
}

variable "cluster_name" {
    description = "naming convention"
    type = string
}

data "terraform_remote_state" "db" {
    backend = "local"
    config = {
    path = "../data-storage/mysql/terraform.tfstate"
  }
}

variable "instance_type" {
    description = "Instance type to run"
    type = string
}

variable "min_size" {
    description = "The minimum number of EC2s in the asg"
    type = number
}

variable "max_size"{
    description = "The maximum number of EC2 innstances in the ASG"
    type = number
}

locals {
  http_port = 80
  any_port = 0
  any_protocol = "-1"
  tcp_protocol = "tcp"
  all_ips = ["0.0.0.0/0"]
}
