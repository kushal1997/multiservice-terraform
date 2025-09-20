terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region  = var.aws_region    # leave empty or set to the AWS CLI profile name
}

# Use default VPC
data "aws_vpc" "default" {
  default = true
}

# Get subnets in default VPC - uses aws_subnets (plural) and returns ids[]
data "aws_subnets" "default_vpc_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Security Group in default VPC
resource "aws_security_group" "app_sg" {
  name        = "multiservice-sg"
  description = "Allow HTTP and backend ports"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3001
    to_port     = 3004
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 in first available default subnet
resource "aws_instance" "app" {
  ami           = var.ami_id           # better to pass AMI per-region via variable
  instance_type = var.instance_type
  subnet_id     = data.aws_subnets.default_vpc_subnets.ids[0]
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  user_data = <<-EOF
    #!/bin/bash
    apt-get update -y
    apt-get install -y docker.io
    systemctl enable docker
    systemctl start docker

    docker network create multiverse_net || true

    docker pull ${var.frontend_image}
    docker pull ${var.user_image}
    docker pull ${var.product_image}
    docker pull ${var.cart_image}
    docker pull ${var.order_image}

    docker run -d --name user --network multiverse_net -e PORT=3001 -e MONGODB_URI="${var.atlas_user_uri}" -e JWT_SECRET="${var.jwt_secret}" -p 3001:3001 ${var.user_image}
    docker run -d --name product --network multiverse_net -e PORT=3002 -e MONGODB_URI="${var.atlas_product_uri}" -p 3002:3002 ${var.product_image}
    docker run -d --name cart --network multiverse_net -e PORT=3003 -e MONGODB_URI="${var.atlas_cart_uri}" -e PRODUCT_SERVICE_URL=http://product:3002 -p 3003:3003 ${var.cart_image}
    docker run -d --name order --network multiverse_net -e PORT=3004 -e MONGODB_URI="${var.atlas_order_uri}" -e CART_SERVICE_URL=http://cart:3003 -e PRODUCT_SERVICE_URL=http://product:3002 -e USER_SERVICE_URL=http://user:3001 -p 3004:3004 ${var.order_image}

    docker run -d --name frontend --network multiverse_net -p 80:80 ${var.frontend_image}
  EOF

  tags = {
    Name = "multiservice-app-instance"
  }
}
