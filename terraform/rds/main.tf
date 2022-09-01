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

resource "aws_db_instance" "bp_kurikulum" {
  allocated_storage      = 8
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  identifier             = "rds-bp-kurikulum"
  db_name                = var.db_database
  username               = var.db_username
  password               = var.db_password
  vpc_security_group_ids = ["sg-03b93748bea3e1a39"]
  publicly_accessible    = true
  parameter_group_name   = "default.mysql5.7"
  skip_final_snapshot    = true


  provisioner "local-exec" {
    working_dir = "../../cilist/database"
    command     = "mysql -u${self.username} -p${self.password} ${self.db_name} -h ${self.address} < crud_db.sql"
  }
}

output "db_host" {
  value = aws_db_instance.bp_kurikulum.address
}
