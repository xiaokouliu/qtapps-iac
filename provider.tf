terraform {
  required_providers {
    tencentcloud = {
      source = "tencentcloudstack/tencentcloud"
      version = "1.81.76"
    }
  }
}

provider "tencentcloud" {
  secret_id = var.tencentcloud_secret_id
  secret_key = var.tencentcloud_secret_key
  region = var.tencentcloud_region
}