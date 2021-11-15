provider "aws" {
  version = "~> 2.0"
  region  = "us-east-1" # Setting my region to London. Use your own region here
}

resource "aws_ecr_repository" "my_first_ecr_repo1" {
  name = "my-first-ecr-repo1" # Naming my repository
}

resource "aws_ecs_cluster" "my_cluster" {
  name = "my-cluster" # Naming the cluster
}

resource "aws_ecs_task_definition" "my_first_task" {
  family                   = "my-first-task" # Naming our first task
  container_definitions    = <<DEFINITION
  [
    {
      "name": "my-first-task",
      "image": "${aws_ecr_repository.my_first_ecr_repo1.repository_url}",
      "essential": true,
      "portMappings": [
        {
          "containerPort": 3000,
          "hostPort": 3000
        }
      ],
      "memory": 512,
      "cpu": 256
    }
  ]
  DEFINITION
  requires_compatibilities = ["FARGATE"] # Stating that we are using ECS Fargate
  network_mode             = "bridge"    # Using awsvpc as our network mode as this is required for Fargate
  memory                   = 512         # Specifying the memory our container requires
  cpu                      = 256         # Specifying the CPU our container requires
  execution_role_arn       = "${aws_iam_role.ecsTaskExecutionRole.arn}"
}

resource "aws_iam_role" "ecsTaskExecutionRole" {
  name               = "ecsTaskExecutionRole"
  assume_role_policy = "${data.aws_iam_policy_document.assume_role_policy.json}"
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy" {
  role       = "${aws_iam_role.ecsTaskExecutionRole.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


resource "aws_ecs_service" "my_first_service" {
  name            = "my-first-service"                             # Naming our first service
  cluster         = "${aws_ecs_cluster.my_cluster.id}"             # Referencing our created Cluster
  task_definition = "${aws_ecs_task_definition.my_first_task.arn}" # Referencing the task our service will spin up
  launch_type     = "FARGATE"
  desired_count   = 3 # Setting the number of containers we want deployed to 3
}

resource "aws_vpc" "vpc" {
    cidr_block = "10.0.0.0/16"
    enable_dns_support   = true
    enable_dns_hostnames = true
    tags       = {
        Name = "awsvpc"
    }
}
resource "aws_subnet" "subnet_dev" {
    vpc_id                  = aws_vpc.vpc.id
    cidr_block              = "10.0.1.0/24"
   tags       = {
        Name = "subnet_dev"
    }
}
output "aws_subnet_subnet_dev" {
  value = "${aws_subnet.subnet_dev.id}"
}
resource "aws_subnet" "subnet_prod" {
    vpc_id                  = aws_vpc.vpc.id
    cidr_block              = "10.0.2.0/24"
   tags       = {
        Name = "subnet_prod"
    }
}

output "aws_subnet_subnet_prod" {
  value = "${aws_subnet.subnet_prod.id}"
}
 # network_configuration {
  #  subnets          = ["${aws_subnet.subnet_dev.id}", "${aws_subnet.subnet_prod.id}"]
   # assign_public_ip = true # Providing our containers with public IPs
  #}
#}
