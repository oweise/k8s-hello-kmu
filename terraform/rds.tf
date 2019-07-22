resource "aws_subnet" "k8s_hello_kmu_rds_subnet" {
  vpc_id     = "${data.aws_vpc.eks_vpc.id}"
  cidr_block = "192.168.192.0/19"
  tags = {
    Name = "Main"
  }
}

resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = ["${aws_subnet.frontend.id}", "${aws_subnet.backend.id}"]

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_db_instance" "k8s_hello_kmu_rds" {
  allocated_storage    = 10
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "10.7"
  instance_class       = "db.m5.large"
  name                 = "k8s_hello_kmu"
  username             = "${var.database_user}"
  password             = "${var.database_password}"
  multi_az             = false
  db_subnet_group_name = "${aws_subnet.k8s_hello_kmu_rds_subnet.id}"
}

resource "aws_db_instance" "k8s_hello_kmu_rds_replica1" {
  allocated_storage    = 10
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "10.7"
  instance_class       = "db.m5.large"
  name                 = "k8s_hello_kmu"
  username             = "${var.database_user}"
  password             = "${var.database_password}"
  multi_az             = false
  db_subnet_group_name = "${aws_subnet.k8s_hello_kmu_rds_subnet.id}"
  replicate_source_db  = "${aws_db_instance.k8s_hello_kmu_rds.id}"
}