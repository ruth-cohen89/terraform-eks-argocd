variable "region" {
  default = "il-central-1"
}

variable "eks_cluster_name" {
  type = string
  default = "eks-cluster"
}

variable "env" {
  description = "Environment for the EKS cluster (dev, prod, etc.)"
  type        = string
  default     = "dev" 
}

variable "argocd_chart_version" {
  type    = string
  default = "7.6.12"
}

variable "argocd_chart_name" {
  type    = string
  default = "argo-cd"
}

variable "argocd_k8s_namespace" {
  type    = string
  default = "argo-cd"
}
