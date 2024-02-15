/*
Cloud-Native PostgreSQL with Kubernetes

Ref:
- https://github.com/ballj/terraform-kubernetes-postgresql/tree/master
*/

# PostgreSQL is deployed within a separate Kubernetes namespace
resource "kubernetes_namespace" "postgresql" {
  metadata {
    name = "postgresql"
  }
}

# This is the persistent volume claim that the PostgreSQL deployment will use
resource "kubernetes_persistent_volume_claim" "postgresql" {
  metadata {
    name = "postgresql-data"
    namespace = kubernetes_namespace.postgresql.metadata[0].name
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "10Gi"
      }
    }
  }
}

# Kubernetes Deployment of PostgreSQL
resource "kubernetes_deployment" "postgresql_deployment" {
  metadata {
    name = "postgresql-deployment"
  }

  spec {
    strategy {
      type = "Recreate"
    }

    selector {
      match_labels = {
        app = "postgresql"
      }
    }

    template {
      metadata {
        labels = {
          app = "postgresql"
        }
      }

      spec {
        container {
          image = "postgres:12.1"
          name  = "postgresql"

          env {
            name  = "POSTGRES_PASSWORD"
            value = "pgsql@123"
          }

          port {
            container_port = 5432
            name           = "postgresql"
          }

          volume_mount {
            name       = "postgresql-persistent-storage"
            mount_path = "/var/lib/postgresql/data"
          }
        }

        volume {
          name =  "postgresql-persistent-storage"

          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.postgresql.metadata[0].name
          }
        }
      }
    }
  }
}

# Kubernetes Service of PostgreSQL
resource "kubernetes_service" "postgresql" {
  metadata {
    name = "postgresql"
    namespace = kubernetes_namespace.postgresql.metadata[0].name
    labels = {
      app = "postgresql"
    }
  }
  spec {
    port {
      name = "postgresql"
      protocol = "TCP"
      port = 5432
      target_port = 5432
    }
  }
}
