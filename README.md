# 量潮应用系统基础设施

使用基础设施即代码(Infrastructure as Code, IaC)的事实标准Terraform描述量潮应用系统基础设施的资源编排，代码化地集中管理基础设施。

项目目录遵循[Terraform官方规范](https://developer.hashicorp.com/terraform/language/modules/develop/structure)。

## 配置源

Windows系统配置`terraform.rc`到用户的`%APPDATA%`目录中；
Unix系统配置`.terraformrc`文件到用户的 home 目录。

内容如下：
```
provider_installation {
    network_mirror {
        url = "https://mirrors.tencent.com/terraform/"
        include = ["registry.terraform.io/tencentcloudstack/*"]
    }
    direct {
        exclude = ["registry.terraform.io/tencentcloudstack/*"]
    }
}
```

参考[腾讯云官方文档](https://cloud.tencent.com/document/product/1653/82912)。

## 初始化

```shell
terraform init
```

## 预览

```shell
terraform plan
```

## 部署

```shell
terraform apply
```

## 删除

```shell
 terraform destroy
 ```