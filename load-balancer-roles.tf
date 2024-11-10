# data "aws_iam_policy_document" "aws_load_balancer_controller_assume_role_policy" {
#   statement {
#     actions = ["sts:AssumeRoleWithWebIdentity"]
#     effect  = "Allow"

#     condition {
#       test     = "StringEquals"
#       variable = "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub"
#       values   = ["system:serviceaccount:kube-system:aws-load-balancer-controller"]
#     }

#     principals {
#       identifiers = [aws_iam_openid_connect_provider.eks.arn]
#       type        = "Federated"
#     }
#   }
# }

# resource "aws_iam_role" "aws_load_balancer_controller" {
#   assume_role_policy = data.aws_iam_policy_document.aws_load_balancer_controller_assume_role_policy.json
#   name               = "aws-load-balancer-controller"
# }

# resource "aws_iam_policy" "aws_load_balancer_controller" {
#   policy = file("./AWSLoadBalancerController.json")
#   name   = "AWSLoadBalancerController"
# }

# # Attach the custom policy (AWSLoadBalancerController) to the IAM role
# resource "aws_iam_role_policy_attachment" "aws_load_balancer_controller_attach" {
#   role       = aws_iam_role.aws_load_balancer_controller.name
#   policy_arn = aws_iam_policy.aws_load_balancer_controller.arn
# }

# # Attach the AmazonEC2FullAccess policy to the IAM role
# resource "aws_iam_role_policy_attachment" "aws_load_balancer_controller_attach_ec2" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
#   role       = aws_iam_role.aws_load_balancer_controller.name
# }

# # Attach the AmazonElasticLoadBalancingFullAccess policy to the IAM role
# resource "aws_iam_role_policy_attachment" "aws_load_balancer_controller_attach_lb" {
#   policy_arn = "arn:aws:iam::aws:policy/ElasticLoadBalancingFullAccess"
#   role       = aws_iam_role.aws_load_balancer_controller.name
# }

# # Attach the AmazonVPCFullAccess policy to the IAM role
# resource "aws_iam_role_policy_attachment" "aws_load_balancer_controller_attach_vpc" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonVPCFullAccess"
#   role       = aws_iam_role.aws_load_balancer_controller.name
# }

# # Attach the IAMReadOnlyAccess policy to the IAM role
# resource "aws_iam_role_policy_attachment" "aws_load_balancer_controller_attach_iam_readonly" {
#   policy_arn = "arn:aws:iam::aws:policy/IAMReadOnlyAccess"
#   role       = aws_iam_role.aws_load_balancer_controller.name
# }

# # Attach the AmazonEKSClusterPolicy policy to the IAM role
# resource "aws_iam_role_policy_attachment" "aws_load_balancer_controller_attach_eks_cluster" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
#   role       = aws_iam_role.aws_load_balancer_controller.name
# }

# output "aws_load_balancer_controller_role_arn" {
#   value = aws_iam_role.aws_load_balancer_controller.arn
# }

# data "tls_certificate" "eks" {
#   url = aws_eks_cluster.eks.identity[0].oidc[0].issuer
# }

# resource "aws_iam_openid_connect_provider" "eks" {
#   client_id_list  = ["sts.amazonaws.com"]
#   thumbprint_list = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]
#   url             = aws_eks_cluster.eks.identity[0].oidc[0].issuer
# }

# # Attach the AmazonEC2ReadOnlyAccess policy to the IAM role
# resource "aws_iam_role_policy_attachment" "aws_load_balancer_controller_attach_ec2_readonly" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
#   role       = aws_iam_role.aws_load_balancer_controller.name
# }