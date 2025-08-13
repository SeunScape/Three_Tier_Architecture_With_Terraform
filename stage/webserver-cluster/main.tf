module web_server {
  source = "../../modules/services/webserver-cluster"
  
  cluster_name = "test-cluster"

  instance_type = "m4.large"
  min_size = 2
  max_size = 10
}
