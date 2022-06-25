module "eks_metrics_server" {
  source = "./modules/metrics_server"

  enabled = true
}

module "eks_cluster_autoscaler" {
  source = "./modules/eks_cluster_autoscaler"

  enabled = true

  cluster_name                     = module.eks.cluster_id
  cluster_identity_oidc_issuer     = module.eks.cluster_oidc_issuer_url
  cluster_identity_oidc_issuer_arn = module.eks.oidc_provider_arn
  aws_region                       = var.aws_region
}