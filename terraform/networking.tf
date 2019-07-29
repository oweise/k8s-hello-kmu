resource "aws_vpc" "rds" {
  cidr_block = "${var.rds_vpc_cidr}"
  enable_dns_hostnames = true
  tags = {
    Name = "rds"
  }
}

resource "aws_route_table" "rds" {
  vpc_id = "${aws_vpc.rds.id}"

  route {
    cidr_block    = "${data.aws_vpc.eks_vpc.cidr_block}"
    vpc_peering_connection_id = "${aws_vpc_peering_connection.eks-to-rds.id}"
  }

  tags = {
    Name = "rds"
  }
}

resource "aws_subnet" "rds" {
  count                   = "${length(var.rds_subnet_azs)}"
  vpc_id                  = "${aws_vpc.rds.id}"
  cidr_block              = "${cidrsubnet(var.rds_vpc_cidr, 8, count.index)}"
  availability_zone       = "${var.rds_subnet_azs[count.index]}"
  tags = {
    Name = "rds-${count.index}}"
  }
}

resource "aws_route_table_association" "rds" {
  count                   = "${length(aws_subnet.rds)}"
  subnet_id               = "${aws_subnet.rds[count.index].id}"
  route_table_id          = "${aws_route_table.rds.id}"
}

resource "aws_db_subnet_group" "rds" {
  name        = "rds-subnet-group"
  subnet_ids  = "${aws_subnet.rds[*].id}"
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

