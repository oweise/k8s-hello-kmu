resource "aws_vpc" "rds" {
  cidr_block = "${var.rds_vpc_cidr}"
  enable_dns_hostnames = true
  tags = {
    Name = "rds"
  }
}

locals {
  rds_subnets = ["rds1", "rds2", "rds3"]
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

data "aws_route_table" "rds_route_tables" {
  count = "${length(local.rds_subnets)}"
  subnet_id = "${local.rds_subnets[count.index]}"
}

locals {
  distinct_rds_route_tables = "${distinct(data.aws_route_table.rds_route_tables[*].id)}"
}

resource "aws_route" "rds-to-eks" {
  count                     = "${length(local.distinct_rds_route_tables)}"
  route_table_id            = "${local.distinct_rds_route_tables[count.index]}"
  destination_cidr_block    = "${data.aws_vpc.eks_vpc.cidr_block}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.eks-to-rds.id}"
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

data "aws_subnet" "eks_subnets" {
  count = "${length(data.aws_eks_cluster.eks.vpc_config[0].subnet_ids)}"
  id = "${tolist(data.aws_eks_cluster.eks.vpc_config[0].subnet_ids)[count.index]}"
}

data "aws_route_table" "eks_route_tables" {
        count = "${length(data.aws_subnet.eks_subnets)}"
        subnet_id = "${data.aws_subnet.eks_subnets[count.index].id}"
}

locals {
        distinct_eks_route_tables = "${distinct(data.aws_route_table.eks_route_tables[*].id)}"
}

resource "aws_route" "eks-to-rds" {
  count                     = "${length(local.distinct_eks_route_tables)}"
  route_table_id            = "${local.distinct_eks_route_tables[count.index]}"
  destination_cidr_block    = "${var.rds_vpc_cidr}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.eks-to-rds.id}"
}

