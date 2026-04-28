# AWS Provider
provider "aws" {
  region = var.aws_region
}

# VPC and Security Group
resource "aws_security_group" "healthroute_sg" {
  name        = "healthroute-sg"
  description = "Allow web and ssh traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
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

# EC2 Instance
resource "aws_instance" "healthroute_server" {
  ami           = var.ami_id
  instance_type = "m7i-flex.large" # Free Tier
  key_name      = var.key_name

  vpc_security_group_ids = [aws_security_group.healthroute_sg.id]

  tags = {
    Name = "HealthRoute-Production"
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get install -y docker.io docker-compose
              sudo systemctl start docker
              sudo systemctl enable docker
              sudo usermod -aG docker ubuntu
              EOF
}
