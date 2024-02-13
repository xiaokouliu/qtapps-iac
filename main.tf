/*
虚拟网络(VPC)
*/

# 虚拟网络(VPC)
resource "tencentcloud_vpc" "qtapps_vpc" {
  name       = format("qtapps-%s", var.env)
  cidr_block = var.tencentcloud_vpc_cidr
}

# 子网(VPC Subnet)
resource "tencentcloud_subnet" "qtapps_vpc_subnet" {
  availability_zone = var.tencentcloud_zone
  vpc_id     = tencentcloud_vpc.qtapps_vpc.id
  name       = format("qtapps-%s", var.env)
  cidr_block = var.tencentcloud_vpc_subnet_cidr
}

/*
块存储(Block Storage)
*/

# 块存储(Block Storage)
# https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/cbs_storage
resource "tencentcloud_cbs_storage" "qtapps_block_storage" {
  storage_name      = format("qtapps-%s", var.env)
  # Valid values:
  # CLOUD_BASIC: HDD cloud disk, CLOUD_PREMIUM: Premium Cloud Storage, CLOUD_BSSD: General Purpose SSD,
  # CLOUD_SSD: SSD, CLOUD_HSSD: Enhanced SSD, CLOUD_TSSD: Tremendous SSD.
  storage_type      = "CLOUD_BSSD"
  # Unit: GB
  storage_size      = 100
  availability_zone = var.tencentcloud_zone
  encrypt           = false
}
