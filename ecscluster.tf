module "ecs_cluster" {
  source = "infrablocks/ecs-cluster/aws"
  version = "3.4.0"

  region = "eu-west-2"
  vpc_id = "vpc-fb7dc365"
  subnet_ids = "subnet-eb32c271,subnet-64872d1f"

  component = "important-component"
  deployment_identifier = "production"

  cluster_name = "services"
  cluster_instance_ssh_public_key_path = "~/.ssh/id_rsa.pub"
  cluster_instance_type = "t2.small"

  cluster_minimum_size = 2
  cluster_maximum_size = 10
  cluster_desired_capacity = 4
}

module "ecs_load_balancer" {
  source = "infrablocks/ecs-load-balancer/aws"
  version = "0.1.10"

  region = "eu-west-2"
  vpc_id = "vpc-fb7dc365"
  subnet_ids = "subnet-ae4533c4,subnet-443e6b12"

  component = "important-component"
  deployment_identifier = "production"

  service_name = "memcache"
  service_port = "11211"
  service_certificate_arn = "arn:aws:acm:eu-west-2:121408295202:certificate/4e0452c7-d32d-4abd-b5f2-69490e83c936"

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