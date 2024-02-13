# TKE集群
resource "tencentcloud_kubernetes_cluster" "qtapps-pgsql" {
  cluster_name      = "qtapps-pgsql"
  vpc_id            = "vpc-xxx" # 请替换为您的VPC ID
  cluster_cidr      = "10.1.0.0/16"
  cluster_max_pod_num = 32
  cluster_max_service_num = 32
  # 根据需要配置其他参数
}
