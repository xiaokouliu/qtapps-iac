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
  default     = "10.0.0.0/16"
}

variable "vpc_subnet_cidr" {
  description = "私有网络子网CIDR"
  type = string
  default     = "10.0.1.0/24"
}

# PostgreSQL服务
variable "kubernetes_cluster_cidr" {
  description = "PostgreSQL集群CIDR"
  type = string
  default     = "172.16.0.0/20"
}

variable "kubernetes_cluster_desc" {
  description = "集群描述"
  type        = string
  default     = "example for tke postgresql cluster"
}

variable "kubernetes_cluster_version" {
  description = "集群版本"
  type        = string
  default     = "1.26.1"
}

variable "kubernetes_deploy_type" {
  description = "集群类型"
  type        = string
  default     = "MANAGED_CLUSTER"
}

variable "kubernetes_cluster_os" {
  description = "集群系统"
  type        = string
  default     = "centos7.6.0_x64"
}

variable "kubernetes_container_runtime" {
  description = "集群运行时类型"
  type        = string
  default     = "containerd"
}

variable "scale_instance_type" {
  description = "集群节点类型"
  type        = string
  default     = "S5.MEDIUM2"
}

variable "system_disk_type" {
  description = "集群节点系统盘类型"
  type        = string
  default     = "CLOUD_SSD"
}

variable "disk_type" {
  description = "集群节点数据盘类型"
  type        = string
  default     = "CLOUD_PREMIUM"
}

variable "internet_charge_type" {
  description = "集群节点公网类型"
  type        = string
  default     = "TRAFFIC_POSTPAID_BY_HOUR"
}

variable "password" {
  description = "集群节点密码"
  type        = string
  sensitive   = true
}