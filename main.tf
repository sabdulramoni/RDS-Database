provider "aws" {
    region = "us-east-2"
  
}

resource "aws_db_instance" "prod" {
  allocated_storage    = 10
  db_name              = "mydb"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  username             = "administrator"
  password             = "data.aws_ssm_parameter.rds_passowrd.value"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
}


# Generate Passowrd
resource "random_password" "main" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# Store Passowrd
resource "aws_ssm_parameter" "rds_passowrd" {
  name  = "mydb_password"
  type  = "SecureString"
  value = "random_password.main.result"
}

# Retrieve Passowrd

data "aws_ssm_parameter" "rds_passowrd" {
name =  "mydb_passowrd"
depends_on = [aws_ssm_parameter.rds_passowrd]
}

# Outputs
output "rds_url" {
    value = aws_db_instance.prod.address
  
}

output "rds_port" {
    value = aws_db_instance.prod.port
  
}

output "rds_username" {
    value = aws_db_instance.prod.username
  
}