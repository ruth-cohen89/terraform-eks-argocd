resource "aws_iam_role" "eks" {
  name = "${var.eks_cluster_name}-${var.env}"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

# EKS Cluster Role Attachments
resource "aws_iam_role_policy_attachment" "eks-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks.name
}

resource "aws_iam_role_policy_attachment" "eks-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks.name
}

resource "aws_iam_role_policy_attachment" "eks-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks.name
}

resource "aws_iam_role_policy_attachment" "eks-load-balancer-permissions" {
  policy_arn = "arn:aws:iam::aws:policy/ElasticLoadBalancingFullAccess"
  role       = aws_iam_role.eks.name
}

resource "aws_iam_role_policy_attachment" "node-group-load-balancer-permissions" {
  policy_arn = "arn:aws:iam::aws:policy/ElasticLoadBalancingFullAccess"
  role       = aws_iam_role.node-group.name
}
# Attach EC2MetadataAccess for EKS Cluster Role
resource "aws_iam_role_policy_attachment" "eks-EC2MetadataAccess-attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
  role       = aws_iam_role.eks.name
}

resource "aws_iam_role" "node-group" {
  name = "eks-node-group-role-${var.env}"

  assume_role_policy = jsonencode({
    Statement = [ {
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    } ]
    Version = "2012-10-17"
  })
}

# Node Group Role Attachments
resource "aws_iam_role_policy_attachment" "node-group-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node-group.name
}

resource "aws_iam_role_policy_attachment" "node-group-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node-group.name
}

resource "aws_iam_role_policy_attachment" "node-group-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node-group.name
}



# Additional Node Group Role Attachment for Cluster Autoscaler Permissions
resource "aws_iam_role_policy_attachment" "node-group-AutoScalingFullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AutoScalingFullAccess"
  role       = aws_iam_role.node-group.name
}

# Attach EC2MetadataAccess for Node Group Role
resource "aws_iam_role_policy_attachment" "node-group-EC2MetadataAccess-attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
  role       = aws_iam_role.node-group.name
}

# Cluster Autoscaler Policy for Node Group Role
resource "aws_iam_role_policy" "node-group-ClusterAutoscalerPolicy" {
  name = "eks-cluster-auto-scaler"
  role = aws_iam_role.node-group.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeAutoScalingInstances",
          "autoscaling:DescribeLaunchConfigurations",
          "autoscaling:DescribeTags",
          "autoscaling:SetDesiredCapacity",
          "autoscaling:TerminateInstanceInAutoScalingGroup"
        ],
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}
# Attach EC2 Full Access to Node Group Role
resource "aws_iam_role_policy_attachment" "node-group-AmazonEC2FullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
  role       = aws_iam_role.node-group.name
}
