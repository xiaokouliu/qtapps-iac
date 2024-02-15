/*
Provider settings for PostgreSQL module

Ref:
- https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/guides/getting-started
*/

terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
  }
}

provider "kubernetes" {
  config_path = var.kube_config_path
}
