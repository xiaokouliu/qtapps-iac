# 腾讯云插件没有上传到Terraform官方，需要手动指定Provider。
terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      # 通过version指定版本
      # 暂不清楚版本的必要性
      version = ">= 2.0.0"
    }
    tencentcloud = {
      source = "tencentcloudstack/tencentcloud"
      # 通过version指定版本
      # 暂不清楚版本的必要性
      version = ">=1.77.7"
    }
  }
}

provider "tencentcloud" {
  region = "ap-shanghai"
  secret_id = var.tencentcloud_secert_id
  secret_key = var.tencentcloud_secert_key
}

module "tencentcloud_tke" {
  source         = "github.com/terraform-tencentcloud-modules/terraform-tencentcloud-tke"
  available_zone = "ap-hongkong-3" # Available zone must belongs to the region.
}

provider "kubernetes" {
  host                   = module.tencentcloud_tke.cluster_endpoint
  cluster_ca_certificate = module.tencentcloud_tke.cluster_ca_certificate
  client_key             = base64decode(module.tencentcloud_tke.client_key)
  client_certificate     = base64decode(module.tencentcloud_tke.client_certificate)
}
