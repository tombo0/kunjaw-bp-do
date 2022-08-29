terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  shared_config_files      = ["/home/taufik/.aws/config"]
  shared_credentials_files = ["/home/taufik/.aws/credentials"]
  profile                  = "default"
}

resource "aws_instance" "jenkins" {
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = var.key_name
  vpc_security_group_ids      = var.vpc_security_group_ids
  associate_public_ip_address = var.associate_public_ip_address

  tags = {
    Name = "BP Jenkins"
  }
}

output "public_dns" {
  value = aws_instance.jenkins.public_dns
}