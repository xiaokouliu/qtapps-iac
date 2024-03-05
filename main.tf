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

# 安全组
resource "tencentcloud_security_group" "qtapps_sg" {
  name = "qtapps_sg"
}

resource "tencentcloud_security_group_lite_rule" "qtapps_sg_rule" {
  security_group_id = tencentcloud_security_group.qtapps_sg.id

  ingress = [
    "ACCEPT#0.0.0.0/0#443#TCP",
  ]

  egress = [
    "ACCEPT#0.0.0.0/0#ALL#TCP",
  ]
}

/*
容器集群
*/

# Kubernetes集群
# https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/kubernetes_cluster
resource "tencentcloud_kubernetes_cluster" "qtapps_pgsql_cluster" {
  cluster_name               = format("qtapps-%s", var.env)
  vpc_id                     = tencentcloud_vpc.qtapps_vpc.id
  cluster_cidr               = var.kubernetes_cluster_cidr
  cluster_max_pod_num        = 32
  cluster_max_service_num    = 32
  cluster_desc               = var.kubernetes_cluster_desc
  cluster_version            = var.kubernetes_cluster_version
  cluster_deploy_type        = var.kubernetes_deploy_type
  acquire_cluster_admin_role = true
  auto_upgrade_cluster_level = false
  cluster_level              = "L5"
  cluster_ipvs               = true
  cluster_os                 = var.kubernetes_cluster_os
  container_runtime          = var.kubernetes_container_runtime
}

resource "tencentcloud_kubernetes_scale_worker" "qtapps_pgsql_cluster_node" {
  cluster_id      = tencentcloud_kubernetes_cluster.qtapps_pgsql_cluster.id
  desired_pod_num = 16
  worker_config {
    count                      = 1
    availability_zone          = var.tencentcloud_zone
    instance_type              = var.scale_instance_type
    subnet_id                  = tencentcloud_subnet.qtapps_vpc_subnet.id
    system_disk_type           = var.system_disk_type
    system_disk_size           = 50
    internet_charge_type       = "TRAFFIC_POSTPAID_BY_HOUR"
    internet_max_bandwidth_out = 100
    public_ip_assigned         = true

    data_disk {
      disk_type = var.disk_type
      disk_size = 50
    }

    enhanced_security_service = false
    enhanced_monitor_service  = false
    password                  = var.password
  }
}

resource "tencentcloud_kubernetes_cluster_endpoint" "example" {
  cluster_id                      = tencentcloud_kubernetes_cluster.qtapps_pgsql_cluster.id
  cluster_internet                = true
  cluster_internet_security_group = tencentcloud_security_group.qtapps_sg.id
  depends_on                      = [
    tencentcloud_kubernetes_scale_worker.qtapps_pgsql_cluster_node
  ]
}

data "tencentcloud_kubernetes_clusters" "tke_list" {
  cluster_name            = tencentcloud_kubernetes_cluster.qtapps_pgsql_cluster.cluster_name
  depends_on              = [
    tencentcloud_kubernetes_cluster_endpoint.example
  ]
}

locals {
  kube_config_raw = data.tencentcloud_kubernetes_clusters.tke_list.list[0].kube_config
  kube_config     = try(yamldecode(local.kube_config_raw), "")
  certification_authority =  data.tencentcloud_kubernetes_clusters.tke_list.list[0].certification_authority
  cluster_external_endpoint = data.tencentcloud_kubernetes_clusters.tke_list.list[0].cluster_external_endpoint
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
  source                 = "./modules/pgsql"
  disk_id                = tencentcloud_cbs_storage.qtapps_pgsql_storage.id
  cluster_ca_certificate = local.certification_authority
  client_key             = base64decode(try(local.kube_config.users[0].user["client-key-data"], ""))
  client_certificate     = base64decode(try(local.kube_config.users[0].user["client-certificate-data"], ""))
  cluster_endpoint       = local.cluster_external_endpoint
}