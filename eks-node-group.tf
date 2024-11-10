resource "aws_eks_node_group" "private" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "private-node-group-${var.env}"
  node_role_arn   = aws_iam_role.node-group.arn
  subnet_ids      = [aws_subnet.private[0].id, aws_subnet.private[1].id]

  labels          = {
    "type" = "private"
  }

  instance_types = ["t3.small"]

  scaling_config {
    desired_size = 1
    max_size     = 3
    min_size     = 1
  }

depends_on = [
  aws_iam_role_policy_attachment.node-group-AmazonEKSWorkerNodePolicy,
  aws_iam_role_policy_attachment.node-group-AmazonEKS_CNI_Policy,
  aws_iam_role_policy_attachment.node-group-AmazonEC2ContainerRegistryReadOnly,
  aws_iam_role_policy_attachment.node-group-load-balancer-permissions,  # Load balancer permissions
  aws_iam_role_policy_attachment.node-group-AutoScalingFullAccess,  # Autoscaler permissions
  aws_iam_role_policy_attachment.node-group-EC2MetadataAccess-attachment,  # Ensure EC2 Metadata Access policy is applied
  aws_iam_role_policy_attachment.node-group-AmazonEC2FullAccess
]

  tags = {
    Environment = var.env
  }
}

resource "aws_eks_node_group" "public" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "public-node-group-${var.env}"
  node_role_arn   = aws_iam_role.node-group.arn
  subnet_ids      = [aws_subnet.public[0].id, aws_subnet.public[1].id]

  labels          = {
    "type" = "public"
  }

  instance_types = ["t3.small"]

  scaling_config {
    desired_size = 1
    max_size     = 3
    min_size     = 1
  }

depends_on = [
  aws_iam_role_policy_attachment.node-group-AmazonEKSWorkerNodePolicy,
  aws_iam_role_policy_attachment.node-group-AmazonEKS_CNI_Policy,
  aws_iam_role_policy_attachment.node-group-AmazonEC2ContainerRegistryReadOnly,
  aws_iam_role_policy_attachment.node-group-load-balancer-permissions,  # Load balancer permissions
  aws_iam_role_policy_attachment.node-group-AutoScalingFullAccess,  # Autoscaler permissions
  aws_iam_role_policy_attachment.node-group-EC2MetadataAccess-attachment  # Ensure EC2 Metadata Access policy is applied

]


  tags = {
    Environment = var.env
  }
}