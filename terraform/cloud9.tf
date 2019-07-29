resource "aws_cloud9_environment_ec2" "console" {
  instance_type               = "t2.micro"
  name                        = "${var.eks_cluster_name}.console"
  automatic_stop_time_minutes = 60
  subnet_id                   = "${data.aws_subnet.eks_subnets[0].id}"
}