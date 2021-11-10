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
