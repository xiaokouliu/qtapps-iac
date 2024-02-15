/*
Cloud-Native Vault with Kubernetes and Consul
*/

resource "helm_release" "vault" {
  repository = "https://helm.releases.hashicorp.com"
  chart      = "vault"
  name       = "vault"
  namespace  = var.vault_namespace

  set {
    name  = "server.dev.enabled"
    value = "true"
  }
  values = [
    # JSON格式编码
    # values的值只能是字符串格式
    jsonencode({
      server = {
        service = {
          type = var.vault_service_type
        }
      }
    })
  ]
}
