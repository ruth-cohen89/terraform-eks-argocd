

# ################################################################################
# # Load Balancer Role
# ################################################################################

# module "lb_role" {
#   source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

#   role_name                              = "${var.env}_eks_lb"
#   attach_load_balancer_controller_policy = true

#   oidc_providers = {
#     main = {
#       provider_arn               = var.oidc_provider_arn
#       namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
#     }
#   }
# }

# ################################################################################
# # Aws Load balancer Controller Service Account
# ################################################################################

# resource "kubernetes_service_account" "service-account" {
#   metadata {
#     name      = "aws-load-balancer-controller"
#     namespace = "kube-system"
#     labels = {
#       "app.kubernetes.io/name"      = "aws-load-balancer-controller"
#       "app.kubernetes.io/component" = "controller"
#     }
#     annotations = {
#       "eks.amazonaws.com/role-arn"               = module.lb_role.iam_role_arn
#       "eks.amazonaws.com/sts-regional-endpoints" = "true"
#     }
#   }
# }

# ################################################################################
# # Install Load Balancer Controler With Helm
# ################################################################################

# resource "helm_release" "lb" {
#   name       = "aws-load-balancer-controller"
#   repository = "https://aws.github.io/eks-charts"
#   chart      = "aws-load-balancer-controller"
#   namespace  = "kube-system"
#   depends_on = [
#     kubernetes_service_account.service-account
#   ]

#   set {
#     name  = "region"
#     value = var.region
#   }

#   set {
#     name  = "vpcId"
#     value = var.vpc_id
#   }

#   set {
#     name  = "image.repository"
#     value = "602401143452.dkr.ecr.${var.region}.amazonaws.com/amazon/aws-load-balancer-controller"
#   }

#   set {
#     name  = "serviceAccount.create"
#     value = "false"
#   }

#   set {
#     name  = "serviceAccount.name"
#     value = "aws-load-balancer-controller"
#   }

#   set {
#     name  = "clusterName"
#     value = aws_eks_cluster.eks.name
#   }
# }


# terraform/helm-load-balancer-controller.tf

module "aws_load_balancer_controller_irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.3.1"

  role_name = "aws-load-balancer-controller"

  attach_load_balancer_controller_policy = true

  oidc_providers = {
    ex = {
      provider_arn               = var.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }
}
# terraform/helm-load-balancer-controller.tf

resource "helm_release" "aws_load_balancer_controller" {
  name = "aws-load-balancer-controller"

  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  version    = "1.4.4"

  set {
    name  = "replicaCount"
    value = 1
  }

  set {
    name  = "clusterName"
    value = aws_eks_cluster.eks.name
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    # value = aws_iam_role.aws_load_balancer_controller.arn
    value = module.aws_load_balancer_controller_irsa_role.iam_role_arn

  }


    set {
    name  = "vpcId"
    value = var.vpc_id
  }
set {
    name  = "aws-vpc-id"
    value = "vpc-0d9d45d27c86e0c4d"
  }
}
