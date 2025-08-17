output "lb_dns" {
    value = aws_lb.instance-lb.dns_name
    description = "name of domain of the load balancer"
}