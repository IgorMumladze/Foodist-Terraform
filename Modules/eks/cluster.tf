resource "aws_eks_cluster" "cluster" {
  name     = "${var.project_name}-cluster"
  role_arn = var.eks_cluster_role_arn

  vpc_config {
    subnet_ids = var.subnets
  }
}

resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = "${var.project_name}-node-group"
  node_role_arn   = var.eks_node_role_arn
  subnet_ids      = var.subnets

  ami_type       = var.node_group_ami_type
  disk_size      = var.node_group_disk_size
  instance_types = [var.node_group_instance_type]
  
  scaling_config {
    desired_size = var.node_group_desired_size
    max_size     = var.node_group_max_size
    min_size     = var.node_group_min_size
  }

  update_config {
    max_unavailable = var.node_group_max_unavailable
  }

  tags = {
    "Name" = "${var.project_name}-Nodes"
  }
}

resource "aws_eks_addon" "aws-ebs-csi-driver" {
  cluster_name = aws_eks_cluster.cluster.name
  addon_name   = "aws-ebs-csi-driver"

  depends_on = [aws_eks_node_group.node_group]
}
resource "aws_eks_addon" "kube-proxy" {
  cluster_name = aws_eks_cluster.cluster.name
  addon_name   = "kube-proxy"

  depends_on = [aws_eks_node_group.node_group]
}
resource "aws_eks_addon" "coredns" {
  cluster_name = aws_eks_cluster.cluster.name
  addon_name   = "coredns"

  depends_on = [aws_eks_node_group.node_group]
}
resource "aws_eks_addon" "vpc-cni" {
  cluster_name = aws_eks_cluster.cluster.name
  addon_name   = "vpc-cni"

  depends_on = [aws_eks_node_group.node_group]
}
