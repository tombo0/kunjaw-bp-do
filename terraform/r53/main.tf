terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  shared_config_files      = [ "/home/taufik/.aws/config" ]
  shared_credentials_files = [ "/home/taufik/.aws/credentials" ]
  profile                  = "default"
}

resource "aws_route53_zone" "main" {
  name = "bpkurikulum.my.id"
}

output "namespace" {
  value = aws_route53_zone.main.name_servers
}