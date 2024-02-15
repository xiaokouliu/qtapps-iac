variable "kube_config_path" {
  description = "The Kubernetes config"
  type        = string
  # 使用本地Kubernetes配置文件
  default     = "~/.kube/config"
}
