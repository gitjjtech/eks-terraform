module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = slice(var.availability_zones, 0, length(var.availability_zones))
  private_subnets = slice(var.private_subnets, 0, length(var.private_subnets))
  public_subnets  = slice(var.public_subnets, 0, length(var.public_subnets))

  enable_dns_hostnames = true
  enable_nat_gateway   = true
  single_nat_gateway   = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
    "kubernetes.io/role/elb"                        = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"               = 1
  }

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}