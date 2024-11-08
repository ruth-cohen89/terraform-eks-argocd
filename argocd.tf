data "aws_eks_cluster_auth" "cluster" {
 name = aws_eks_cluster.eks.name
}

resource "kubernetes_namespace" "namespace_argocd" {
depends_on = [
    aws_eks_cluster.eks, 
    aws_eks_node_group.private, 
    aws_eks_node_group.public
  ]
    metadata {
    name = var.argocd_k8s_namespace
  }
}

resource "helm_release" "argocd" {
 depends_on = [
    kubernetes_namespace.namespace_argocd,  # Wait for the namespace to be created first
    aws_eks_cluster.eks,                    # Ensure the EKS cluster is ready
    aws_eks_node_group.private,             # Ensure private node group is available
    aws_eks_node_group.public               # Ensure public node group is available
  ]

 name       = "argocd"
 repository = "https://argoproj.github.io/argo-helm"
 chart      = "argo-cd"
 version    = "7.6.12"

 namespace  = var.argocd_k8s_namespace
 //create_namespace = true

set { 
    name  = "server.name"
    value = "argocd-server"
  }

 set {
   name  = "server.service.type"
   value = "LoadBalancer"
 }

 set {
   name  = "server.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-type"
   value = "nlb"
 }

 
# # Set Helm annotations on the ClusterRole
  set {
    name  = "rbac.create"
    value = "true"
  }

  set {
    name  = "rbac.clusterRole.annotations.app\\.kubernetes\\.io/managed-by"
    value = "Helm"
  }

  set {
    name  = "rbac.clusterRole.annotations.meta\\.helm\\.sh/release-name"
    value = "argocd"
  }

  set {
    name  = "rbac.clusterRole.annotations.meta\\.helm\\.sh/release-namespace"
    value = var.argocd_k8s_namespace
  }

}


data "kubernetes_service" "argocd_server" {
 metadata {
   name      = "argocd-server"
   namespace = helm_release.argocd.namespace
 }

 depends_on = [
  kubernetes_namespace.namespace_argocd,
    aws_iam_role.argocd_role,
    aws_iam_role_policy_attachment.argocd_role_attachment
  ]
  
}