/*
环境标识
*/
variable "env" {
  description = "环境标识"
  type = string
  # 可选值：dev, test, prod
  default = "dev"
}

/*
腾讯云基本配置
*/
variable "tencentcloud_secret_id" {
  description = "腾讯云密钥ID"
  type        = string
  sensitive = true
}

variable "tencentcloud_secret_key" {
  description = "腾讯云密钥值"
  type        = string
  sensitive  = true
}

variable "tencentcloud_project_id" {
  description = "腾讯云项目ID"
  type = number
  default = 0
}

variable "tencentcloud_region" {
  description = "腾讯云区域"
  type = string
  default = "ap-shanghai"
}

variable "tencentcloud_zone" {
  description = "腾讯云可用区"
  type = string
  default = "ap-shanghai-2"
}

/*
云资源配置
*/
# VPC
variable "vpc_cidr" {
  description = "私有网络CIDR"
  type = string
}

variable "vpc_subnet_cidr" {
  description = "私有网络子网CIDR"
  type = string
}

# PostgreSQL服务
variable "kubernetes_cluster_cidr" {
  description = "PostgreSQL集群CIDR"
  type = string
}
