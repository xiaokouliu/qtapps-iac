variable "kube_config_path" {
  description = "The Kubernetes config"
  type        = string
  # 使用本地Kubernetes配置文件
  default     = "./kube_config"
}

variable "cluster_ca_certificate" {
  type        = string
  description = "Cluster's certification authority."
}

variable "client_key" {
  type        = string
  description = "Base64 encoded cluster's client pem key."
}

variable "client_certificate" {
  type        = string
  description = "Base64 encoded cluster's client pem certificate."
}

variable "cluster_endpoint" {
  type        = string
  description = "Cluster endpoint if cluster_public_access or endpoint enabled"
}

variable "disk_id" {
  description = "disk id"
  type        = string
}