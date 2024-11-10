

# provider "kubernetes" {
#   host                   = aws_eks_cluster.eks.endpoint
#   cluster_ca_certificate = base64decode(aws_eks_cluster.eks.cluster_ca_certificate)
#   token                  = data.aws_eks_cluster_auth.eks.token
# }

# provider "helm" {
#   kubernetes {
#     host                   = aws_eks_cluster.eks.endpoint
#     cluster_ca_certificate = base64decode(aws_eks_cluster.eks.cluster_ca_certificate)
#     token                  = data.aws_eks_cluster_auth.eks.token
#   }
# }

# Data sources to get EKS cluster information
# data "aws_eks_cluster" "eks" {
#   name = var.eks_cluster_name
# }

# data "aws_eks_cluster_auth" "eks" {
#   name = var.eks_cluster_name
# }


# provider "helm" {
#   kubernetes {
#     config_path = "~/.kube/config"
#   }
  
# }

# provider "kubernetes" {
#   config_path = "~/.kube/config"
# }

# provider "helm" {
#   kubernetes {
#     host                   = aws_eks_cluster.eks.endpoint
#     cluster_ca_certificate = base64decode(aws_eks_cluster.eks.certificate_authority[0].data)
#     exec {
#       api_version = "client.authentication.k8s.io/v1beta1"
#       args        = ["eks", "get-token", "--cluster-name", aws_eks_cluster.eks.name]
#       command     = "aws"
#     }
#   }
# }

provider "helm" {
  kubernetes {
    host                   = aws_eks_cluster.eks.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.eks.certificate_authority[0].data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", aws_eks_cluster.eks.name]
      command     = "aws"
    }
  }
}
provider "kubernetes" {
  host                   = aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.eks.certificate_authority[0].data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", aws_eks_cluster.eks.name]
    command     = "aws"
  }
}
provider "aws" {
  region = var.region
}

