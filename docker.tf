resource "aws_instance" "docker" {
  ami           = local.ami_id
  instance_type = "t3.medium"

  vpc_security_group_ids = [aws_security_group.docker.id]

  # need more for terraform
  root_block_device {
    volume_size = 50
    volume_type = "gp3" # or "gp2", depending on your preference
  }
  user_data = file("docker.sh")
  #iam_instance_profile = "TerraformAdmin"

  tags = merge (
    local.common_tags,
    {
        Name = "${var.project}-${var.environment}-bastion"
    }

  )
}


resource "aws_security_group" "docker" {
  name        = "docker_sg"
  description = "security gtoup for the docker instance"

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
      create_before_destroy = true
    }

  tags = {
    Name = "allow_all_docker"
  }
}
