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

resource "aws_s3_bucket" "bp" {
  bucket = var.bucket_name

  tags = {
    Name        = "BP Kurikulum"
    Environment = "Prod"
  }
}

resource "aws_s3_bucket_acl" "bp" {
  bucket = aws_s3_bucket.bp.id
  acl    = "private"
}