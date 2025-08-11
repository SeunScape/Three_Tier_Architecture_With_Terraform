output "lb_dns" {
    value = aws_lb.instance-lb.dns_name
    description = "domain of the load balancer"
}