data "local_file" "eks_cluster" {
  filename = "../work/cluster.yml"
}

locals {
  eks_vpc_id = "${yamldecode(data.local_file.eks_cluster.content)[0].ResourcesVpcConfig.VpcId}"
}

resource "aws_subnet" "k8s_hello_kmu_rds_subnet" {
  vpc_id     = "${local.eks_vpc_id}"
  cidr_block = "172.31.0.0/16"
  tags = {
    Name = "Main"
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