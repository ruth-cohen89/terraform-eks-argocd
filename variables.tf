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
variable "oidc_provider_arn" {
  description = "OIDC Provider ARN used for IRSA"
  type        = string
  default     = "arn:aws:iam::499171398741:oidc-provider/oidc.eks.il-central-1.amazonaws.com/id/1B8658157CE3BC0C028CDC6ECF3B6E7D"
}

variable "vpc_id" {
  description = "VPC ID which Load balancers will be  deployed in"
  type = string
  default = "vpc-0d9d45d27c86e0c4d"
}