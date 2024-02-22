variable "db_username" {
  description = "Username for MySQL RDS instance"
}

variable "db_password" {
  description = "Password for MySQL RDS instance"
}

resource "aws_db_subnet_group" "my_db_subnet_group" {
  name       = "my-db-subnet-group"
  subnet_ids = [aws_subnet.db_subnets[0].id, aws_subnet.db_subnets[1].id] // Use the DB subnets you created earlier
}

resource "aws_db_parameter_group" "my_db_parameter_group" {
  name        = "my-db-parameter-group"
  family      = "mysql5.7"
  description = "My DB parameter group"
}

resource "aws_db_instance" "my_db_instance" {
  identifier              = "my-db-instance"
  allocated_storage       = 20
  storage_type            = "gp2"
  engine                  = "mysql"
  engine_version          = "5.7"
  instance_class          = "db.t2.micro"
  #name                    = "mydatabase"
  username                = var.db_username
  password                = var.db_password
  publicly_accessible     = false
  db_subnet_group_name    = aws_db_subnet_group.my_db_subnet_group.name
  parameter_group_name    = aws_db_parameter_group.my_db_parameter_group.name
  vpc_security_group_ids  = [aws_security_group.db_sg.id] // Use the DB security group you created earlier
}
