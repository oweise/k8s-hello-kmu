data "local_file" "eks_cluster" {
  filename = "../work/cluster.yml"
}

locals {
  eks_vpc_id = "${yamldecode(data.local_file.eks_cluster.content)[0].ResourcesVpcConfig.VpcId}"
}

data "aws_vpc" "eks_vpc" {
  id = "${local.eks_vpc_id}"
}