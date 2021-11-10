module "ecs_cluster" {
  source = "infrablocks/ecs-cluster/aws"
  version = "3.4.0"

  region = "us-east-1"
  vpc_id = "vpc-0413727213c90fd60"
  subnet_ids = "subnet-0e4d9be10adee579b,subnet-0583f78d928f94463"

  component = "important-component"
  deployment_identifier = "production"

  cluster_name = "services"
  cluster_instance_ssh_public_key_path = "/home/jenkins/keys/aws_key.pub"
  cluster_instance_type = "t2.micro"

  cluster_minimum_size = 2
  cluster_maximum_size = 4
  cluster_desired_capacity = 4
}

module "ecs_load_balancer" {
  source = "infrablocks/ecs-load-balancer/aws"
  version = "0.1.10"

  region = "us-east-1"
  vpc_id = "vpc-0413727213c90fd60"
  subnet_ids = "subnet-0e4d9be10adee579b,subnet-0583f78d928f94463"

  component = "important-component"
  deployment_identifier = "production"

  service_name = "memcache"
  service_port = "11211"
  service_certificate_arn = "arn:aws:acm:us-east-1:885270470374:certificate/d2b7948f-f15f-4a38-b17e-ab6247572580"

  domain_name = "example.com"
  public_zone_id = "Z1WA3EVJBXSQ2V"
  private_zone_id = "Z3CVA9QD5NHSW3"

  health_check_target = "TCP:11211"

  allow_cidrs = [
    "100.10.10.0/24",
    "200.20.0.0/16"
  ]

  include_public_dns_record = "yes"
  include_private_dns_record = "yes"

  expose_to_public_internet = "yes"
}
