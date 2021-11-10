module "ecs_cluster" {
  source = "infrablocks/ecs-cluster/aws"
  version = "3.4.0"

  region = "us-east-1"
  vpc_id = "vpc-2db7c450"
  subnet_ids = "subnet-b89563f4,subnet-a595b5fa"

  component = "important-component"
  deployment_identifier = "production"

  cluster_name = "services"
  cluster_instance_ssh_public_key_path = "/home/jenkins/keys/aws_key.pub"
  cluster_instance_type = "t2.micro"

  cluster_minimum_size = 2
  cluster_maximum_size = 4
  cluster_desired_capacity = 4
}
