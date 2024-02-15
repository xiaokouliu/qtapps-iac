/*
虚拟网络(VPC)
*/

# 虚拟网络(VPC)
resource "tencentcloud_vpc" "qtapps_vpc" {
  name       = format("qtapps-%s", var.env)
  cidr_block = var.vpc_cidr
}

# 子网(VPC Subnet)
resource "tencentcloud_subnet" "qtapps_vpc_subnet" {
  availability_zone = var.tencentcloud_zone
  vpc_id            = tencentcloud_vpc.qtapps_vpc.id
  name              = format("qtapps-%s", var.env)
  cidr_block        = var.vpc_subnet_cidr
}

/*
容器集群
*/

# Kubernetes集群
# https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/kubernetes_cluster
resource "tencentcloud_kubernetes_cluster" "qtapps_pgsql_cluster" {
  cluster_name            = format("qtapps-%s", var.env)
  vpc_id                  = tencentcloud_vpc.qtapps_vpc.id
  cluster_cidr            = var.kubernetes_cluster_cidr
  cluster_max_pod_num     = 32
  cluster_max_service_num = 32
  # 根据需要配置其他参数
}

/*
PostgreSQL服务
*/

# PostgreSQL存储
# https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/cbs_storage
resource "tencentcloud_cbs_storage" "qtapps_pgsql_storage" {
  storage_name = format("qtapps-pgsql-%s", var.env)
  # Valid values:
  # CLOUD_BASIC: HDD cloud disk, CLOUD_PREMIUM: Premium Cloud Storage, CLOUD_BSSD: General Purpose SSD,
  # CLOUD_SSD: SSD, CLOUD_HSSD: Enhanced SSD, CLOUD_TSSD: Tremendous SSD.
  storage_type = "CLOUD_BSSD"
  # Unit: GB
  storage_size      = 100
  availability_zone = var.tencentcloud_zone
  encrypt           = false
}


# PostgreSQL服务
module "postgresql" {
  source = "./modules/pgsql"
}
