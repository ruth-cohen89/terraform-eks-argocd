# resource "helm_release" "aws-load-balancer-controller" {
#   name       = "aws-load-balancer-controller"
#   repository = "https://aws.github.io/eks-charts"
#   chart      = "aws-load-balancer-controller"
#   namespace  = "kube-system"
#   version    = "1.5.0"

#   set {
#     name  = "clusterName"
#     value = aws_eks_cluster.eks.id  # Use the actual EKS cluster name here
#   }

#   set {
#     name  = "image.tag"
#     value = "v2.4.2"
#   }

#   set {
#     name  = "serviceAccount.name"
#     value = "aws-load-balancer-controller"
#   }

#   set {
#     name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
#     value = aws_iam_role.aws_load_balancer_controller.arn
#   }

#   set {
#     name  = "vpcID"
#     value = "vpc-0d9d45d27c86e0c4d"  # Ensure full VPC ID format
#   }

#   # Optional: Explicitly passing aws-vpc-id to avoid metadata issues
#   set {
#     name  = "aws-vpc-id"
#     value = "vpc-0d9d45d27c86e0c4d"
#   }

#   depends_on = [
#     aws_eks_cluster.eks,
#     aws_eks_node_group.private,
#     aws_eks_node_group.public,
#     aws_iam_openid_connect_provider.eks,  # Ensure the OIDC provider is created first
#     aws_iam_role.aws_load_balancer_controller, 
#     aws_iam_role_policy_attachment.aws_load_balancer_controller_attach,
#     aws_iam_role_policy_attachment.aws_load_balancer_controller_attach_ec2,
#     aws_iam_role_policy_attachment.aws_load_balancer_controller_attach_lb,
#     aws_iam_role_policy_attachment.aws_load_balancer_controller_attach_vpc,
#     aws_iam_role_policy_attachment.aws_load_balancer_controller_attach_iam_readonly,
#     aws_iam_role_policy_attachment.aws_load_balancer_controller_attach_eks_cluster,
#     aws_iam_role_policy_attachment.aws_load_balancer_controller_attach_ec2_readonly
#   ]
# }
