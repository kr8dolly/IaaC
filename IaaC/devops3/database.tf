resource "aws_db_subnet_group" "database" {
  subnet_ids = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
}

resource "aws_db_instance" "database" {
  allocated_storage      = 5
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  port                   = "3306"
  publicly_accessible    = false
  db_subnet_group_name   = aws_db_subnet_group.database.id
  vpc_security_group_ids = [aws_security_group.default.id]
  skip_final_snapshot    = true
  name                   = var.database_name
  username               = var.database_user
  password               = var.database_password
}
