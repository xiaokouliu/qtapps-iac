resource "tencentcloud_cbs_snapshot" "example" {
  region = "ap-guangzhou"
  provider_alias = "default"
}

resource "kubernetes_deployment" "vault" {
  metadata {
    name = "vault-deployment"
    labels = {
      app = "vault"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "vault"
      }
    }

    template {
      metadata {
        labels = {
          app = "vault"
        }
      }

      spec {
        container {
          name = "vault"
          image = "vault:latest"
          # 添加其他所需的配置，例如环境变量、数据卷等
        }
        # 添加其他所需的配置，例如卷挂载、端口暴露等
      }
    }
  }
}