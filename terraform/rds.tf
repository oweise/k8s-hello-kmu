//resource "aws_security_group" "rds" {
//  name        = "rds"
//  vpc_id      = "${aws_vpc.rds.id}"
//  ingress {
//    from_port       = 5432
//    to_port         = 5432
//    protocol        = "tcp"
//  }
//  # Allow all outbound traffic.
//  egress {
//    from_port   = 0
//    to_port     = 0
//    protocol    = "-1"
//    cidr_blocks = ["0.0.0.0/0"]
//  }
//  tags = {
//    Name = "rds"
//  }
//}


resource "aws_db_instance" "k8s_hello_kmu_rds" {
  identifier              = "k8s-hello-kmu"
  allocated_storage       = 10
  storage_type            = "gp2"
  engine                  = "postgres"
  engine_version          = "10.7"
  instance_class          = "db.m5.large"
  name                    = "k8s_hello_kmu"
  username                = "${var.database_user}"
  password                = "${var.database_password}"
  multi_az                = false
  backup_retention_period = 7
  skip_final_snapshot     = true
  db_subnet_group_name    = "${aws_db_subnet_group.rds.name}"
//  security_group_names = ["rds"]
}

resource "aws_db_instance" "k8s_hello_kmu_rds_replica1" {
  identifier           = "k8s-hello-kmu-replica1"
  allocated_storage    = 10
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "10.7"
  instance_class       = "db.m5.large"
  name                 = "k8s_hello_kmu"
  multi_az             = false
  replicate_source_db  = "${aws_db_instance.k8s_hello_kmu_rds.id}"
  skip_final_snapshot  = true
//  security_group_names = ["rds"]
}
