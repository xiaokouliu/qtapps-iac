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
  host                   = var.cluster_endpoint
  cluster_ca_certificate = var.cluster_ca_certificate
  client_key             = var.client_key
  client_certificate     = var.client_certificate
}
