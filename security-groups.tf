resource "aws_security_group" "eks_cluster" {
  name        = "${var.eks_cluster_name}-${var.env}/ControlPlaneSecurityGroup"
  description = "Communication between the control plane and worker nodegroups"
  vpc_id      = aws_vpc.this.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    # Allow communication between control plane and worker nodes
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.eks_cluster_name}-${var.env}/ControlPlaneSecurityGroup"
    Environment = var.env
  }
}

resource "aws_security_group_rule" "cluster_inbound" {
  description              = "Allow unmanaged nodes to communicate with control plane (all ports)"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_eks_cluster.eks.vpc_config[0].cluster_security_group_id
  source_security_group_id = aws_security_group.eks_nodes.id
  to_port                  = 0
  type                     = "ingress"
}


resource "aws_security_group" "eks_nodes" {
  name        = "${var.eks_cluster_name}-${var.env}/ClusterSharedNodeSecurityGroup"
  description = "Communication between all nodes in the cluster"
  vpc_id      = aws_vpc.this.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }
  
  ingress {
    # Allow worker nodes to communicate with control plane (on port 443)
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_eks_cluster.eks.vpc_config[0].cluster_security_group_id]
  }

  ingress {
    # Allow communication for ArgoCD and the Hello World app on specific ports (e.g., HTTP on 8080)
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_eks_cluster.eks.vpc_config[0].cluster_security_group_id]
  }

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_eks_cluster.eks.vpc_config[0].cluster_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.eks_cluster_name}-${var.env}/ClusterSharedNodeSecurityGroup"
    Environment = var.env
  }
}
