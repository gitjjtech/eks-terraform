resource "helm_release" "metrics_server" {
  depends_on = [var.mod_dependency, kubernetes_namespace.metrics_server]
  count      = var.enabled ? 1 : 0
  name       = var.helm_chart_name
  chart      = var.helm_chart_release_name
  repository = var.helm_chart_repo
  version    = var.helm_chart_version
  namespace  = var.namespace
  verify     = false

  set {
    name  = "rbac.create"
    value = "true"
  }

  values = [
    yamlencode(var.settings)
  ]

}