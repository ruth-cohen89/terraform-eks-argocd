terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"  
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"  
    }


    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
  }
  
  required_version = ">= 1.0"
}


# resource "kubernetes_namespace" "ingress_nginx" {
#   metadata {
#     name = "ingress-nginx"
#   }
# }

# resource "kubernetes_manifest" "nginx_ingress_controller" {
#   depends_on = [kubernetes_namespace.ingress_nginx]
#   manifest = yamldecode(file("./nginx-ingress-controller.yaml"))
# }


