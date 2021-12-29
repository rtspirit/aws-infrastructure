// RDS INSTANCE CREATION


locals {
  allocated_storage     = 20
  max_allocated_storage = 100
  multi_az              = false
  skip_final_snapshot   = true
  storage_encrypted     = true
}

resource "aws_db_instance" "db" {
  allocated_storage     = local.allocated_storage
  max_allocated_storage = local.max_allocated_storage
  storage_type          = "gp2"
  // endpoint               = aws_db_instance.db.endpoint
  engine                 = var.engine
  engine_version         = var.engine_version
  instance_class         = "db.t3.micro"
  identifier             = "csye6225"
  name                   = var.rds_name
  username               = var.rds_username
  password               = var.rds_password
  multi_az               = local.multi_az
  skip_final_snapshot    = local.skip_final_snapshot
  db_subnet_group_name   = aws_db_subnet_group.db-subnet.name
  vpc_security_group_ids = ["${aws_security_group.database.id}"]
  storage_encrypted      = local.storage_encrypted
  parameter_group_name   = aws_db_parameter_group.rds.name
  depends_on             = [aws_db_parameter_group.rds]
  availability_zone = "us-east-1a"
}

resource "aws_db_instance" "rds_replica" {
    depends_on = [aws_db_instance.db]
    identifier = "replica-csye6225"
    engine = var.engine
    auto_minor_version_upgrade = true
    engine_version = var.engine_version
    instance_class = "db.t3.micro"
    name = "read_replica_indentifier"
    // multi_az = true
    skip_final_snapshot = true
    publicly_accessible = false
    backup_retention_period = 5
    replicate_source_db = aws_db_instance.db.id
    // db_subnet_group_name = aws_db_subnet_group.replica_awsDbSubnetGrp.name
    availability_zone = "us-east-1b"
}