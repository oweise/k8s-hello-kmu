resource "aws_vpc" "rds" {
  cidr_block = "${var.rds_vpc_cidr}"
  enable_dns_hostnames = true
  tags = {
    Name = "rds"
  }
}

resource "aws_subnet" "rds1" {
  vpc_id                  = "${aws_vpc.rds.id}"
  cidr_block              = "${cidrsubnet(var.rds_vpc_cidr, 8, 0)}"
  availability_zone       = "${var.rds_subnet1_az}"
  tags = {
    Name = "rds-1"
  }
}

resource "aws_subnet" "rds2" {
  vpc_id                  = "${aws_vpc.rds.id}"
  cidr_block              = "${cidrsubnet(var.rds_vpc_cidr, 8, 1)}"
  availability_zone       = "${var.rds_subnet2_az}"
  tags = {
    Name = "rds-2"
  }
}

resource "aws_subnet" "rds3" {
  vpc_id                  = "${aws_vpc.rds.id}"
  cidr_block              = "${cidrsubnet(var.rds_vpc_cidr, 8, 2)}"
  availability_zone       = "${var.rds_subnet3_az}"
  tags = {
    Name = "rds-3"
  }
}
resource "aws_db_subnet_group" "rds" {
  name        = "rds-subnet-group"
  subnet_ids  = ["${aws_subnet.rds1.id}", "${aws_subnet.rds2.id}", "${aws_subnet.rds3.id}"]
}

resource "aws_vpc_peering_connection" "eks-to-rds" {
  peer_vpc_id   = "${aws_vpc.rds.id}"
  vpc_id        = "${data.aws_vpc.eks_vpc.id}"
  auto_accept   = true

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }
}

