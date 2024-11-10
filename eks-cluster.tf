resource "aws_eks_cluster" "eks" {
  name     = "${var.eks_cluster_name}-${var.env}"
  role_arn = aws_iam_role.eks.arn

  vpc_config {
    security_group_ids      = [aws_security_group.eks_cluster.id]
    endpoint_private_access = true
    endpoint_public_access  = true
    # TODO DEFINE VAR: 
    # defines from where we can connect to the cluster via kubectl or ci/cd pipeline
    # public_access_cidrs     = [var.internal_ip_range]
    public_access_cidrs = ["0.0.0.0/0"]

    subnet_ids = [
      aws_subnet.private[0].id, 
      aws_subnet.private[1].id, 
      aws_subnet.public[0].id,   
      aws_subnet.public[1].id   
    ]
  }

  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

depends_on = [
  aws_iam_role_policy_attachment.eks-AmazonEKSClusterPolicy,
  aws_iam_role_policy_attachment.eks-AmazonEKSVPCResourceController,
  aws_iam_role_policy_attachment.eks-AmazonEKSServicePolicy,
  aws_iam_role_policy_attachment.eks-load-balancer-permissions,  # Ensure ELB permissions are attached
  aws_iam_role_policy_attachment.eks-EC2MetadataAccess-attachment,  # Ensure EC2 Metadata Access policy is applied
 # aws_iam_openid_connect_provider.eks  # Add OIDC provider as a dependency

]


  tags = {
    Environment = var.env
  }

  
}