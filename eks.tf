module "eks" {

  source  = "terraform-aws-modules/eks/aws"
  version = "18.23.0"

  cluster_name                         = var.eks_cluster_name
  cluster_version                      = var.eks_cluster_version
  cluster_endpoint_public_access       = true
  cluster_endpoint_private_access      = true
  cluster_endpoint_public_access_cidrs = var.cluster_endpoint_public_access_cidrs

  subnet_ids  = module.vpc.private_subnets
  vpc_id      = module.vpc.vpc_id
  enable_irsa = var.eks_enable_irsa

  cluster_addons = {
    kube-proxy = {
      resolve_conflicts = "OVERWRITE"
    }
    aws-ebs-csi-driver = {
      resolve_conflicts = "OVERWRITE"
    }
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }
  }

  cluster_security_group_tags = {
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "owned"
  }
  node_security_group_tags = {
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "owned"
  }

  # Extend node-to-node security group rules
  node_security_group_additional_rules = {
    cluster_port = {
      description                   = "API server to node group"
      protocol                      = "-1"
      from_port                     = 0
      to_port                       = 0
      type                          = "ingress"
      source_cluster_security_group = true
    }
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
    egress_all = {
      description = "Node all egress"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "egress"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }


  eks_managed_node_groups = {
    general = {
      name                    = "${var.eks_cluster_name}-node-gp"
      vpc_security_group_ids  = [aws_security_group.remote_access.id]
      pre_bootstrap_user_data = <<-EOT
      #!/bin/bash
      set -ex
      cat <<-EOF > /etc/profile.d/bootstrap.sh
      export CONTAINER_RUNTIME="containerd"
      export USE_MAX_PODS=false
      export KUBELET_EXTRA_ARGS="--max-pods=20"
      EOF
      # Source extra environment variables in bootstrap script
      sed -i '/^set -o errexit/a\\nsource /etc/profile.d/bootstrap.sh' /etc/eks/bootstrap.sh
      EOT

      instance_types       = var.node_instance_types
      desired_size         = var.node_count_desired
      max_size             = var.node_count_max
      min_size             = var.node_count_min
      capacity_type        = "ON_DEMAND"
      force_update_version = true
      ebs_optimized        = true
      enable_monitoring    = false
      key_name             = var.node_keyname

      labels = {
        workload = "general"
      }

      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size           = 30
            volume_type           = "gp3"
            iops                  = 3000
            throughput            = 150
            encrypted             = false
            delete_on_termination = true
          }
        }
      }
    }
  }

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_security_group" "remote_access" {
  name_prefix = "node-remote-sg"
  description = "Allow SSH traffic from VPC"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "SSH Ingress traffic from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [
      var.vpc_cidr
    ]
  }

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}
