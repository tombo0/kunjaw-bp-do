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

resource "aws_security_group" "sg_bp_kurikulum" {
  name        = "sg_bp_kurikulum"
  description = "Security Group for "
  vpc_id      = var.vpc

  ingress {
    description      = "Allow All"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Allow SSH and Jenkins"
  }
}

resource "aws_instance" "jenkins" {
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.sg_bp_kurikulum.id]
  associate_public_ip_address = var.associate_public_ip_address

  tags = {
    Name = "BP Jenkins"
  }

  provisioner "local-exec" {
    working_dir = "../../ansible"
    # command     = "ansible-playbook -i ${self.public_dns}, --private-key=$key_path playbook.yaml"
    command     = "pwd"
    environment = {
      key_path = "/home/taufik/Documents/kerja/cilsy/modul/Sekolah Devops/taufik_kurikulum_kp_us-east-2.pem"
    }
  }
}

output "public_dns" {
  value = aws_instance.jenkins.public_dns
}
