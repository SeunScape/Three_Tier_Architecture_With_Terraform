variable "port_number" {
    type = number
    default = 8080
    description = "desctiption for this variable"
}

variable "cluster_name" {
    description = "naming convention"
    type = string
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

# output "alb_security_group_id" {
#     value = aws_security_group.alb.id
#     description = "The ID of the Security Group attached to the load balancer"
# }

locals {
  http_port = 80
  any_port = 0
  any_protocol = "-1"
  tcp_protocol = "tcp"
  all_ips = ["0.0.0.0/0"]
}

#operations
variable user_list {
    description = "array of users"
    type = list(string)
    default = ["david", "cheryl", "paul"]

}

# variable "names" {
#     description = "a map of boys and their hobbies"
#     type = map(string)
#     default = {
#         john : "football"
#         peter : "baseball"
#         jonathan : "cricket"
#     }
# }

# output boys {
#     [for boyhobby : boy in var.names if length(boyhobby) < 10: "${name} is the ${role}" ]
# }

