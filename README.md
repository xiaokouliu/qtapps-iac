# 量潮应用系统基础设施

使用基础设施即代码(Infrastructure as Code, IaC)的事实标准Terraform描述量潮应用系统基础设施的资源编排，代码化地集中管理基础设施。

## 资源

基础：
- 私有网络：隔离环境
- 块存储：数据库等资源提供持久化存储，并独立管理其生命周期

服务：
- PostgreSQL服务：SQL数据库
- Vault服务：密钥管理

## 初始化

### 配置Terraform源

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

### 配置敏感变量

在`terraform.tfvars`（或者以`.auto.tfvars`结尾）中配置腾讯云密钥。

> Terraform automatically loads all files in the current directory with the exact name terraform.tfvars or matching *.auto.tfvars. You can also use the -var-file flag to specify other files by name.

参考[Terraform官方文档](https://developer.hashicorp.com/terraform/tutorials/cli/variables#assign-values-with-a-file)

```tfvars
# 密钥
tencentcloud_secret_id = "<your_secret_id>"
tencentcloud_secret_key = "<your_secret_key>"
```

### 本地项目初始化

```shell
terraform init
```

## 维护和更新

### 项目结构

项目目录遵循[Terraform官方规范](https://developer.hashicorp.com/terraform/language/modules/develop/structure)。

- `main.tf`模块是目前的资源配置声明位置。
- `modules/`由于搞不清楚使用方法，实际上暂未使用。
- `examples/`是一些示例配置，已废弃。

### 命名规范

系统层级的云资源命名采用qtapps-<app>-<env>的格式，如qtapps-pgsql-dev。

### 本地开发

增加新模块：
```shell
terraform get
```

调试语法，确认无误：

```shell
terraform plan
```

尝试部署到云端：

```shell
terraform apply
```

PS：Kubernetes集群部署需要4-5分钟，删除需要1分钟。

为了节约资源，通过以后可以把开发环境的资源删除：

```shell
terraform destory
```

### 云端CI/CD

为测试和生产环境使用两个配置文件，命名暂定terraform-test和terraform-prod。

流程：
1. 本地使用dev环境，直接通过命令行提交。
2. push 触发test环境，不做pre-release，以简化流程
3. release 触发 prod环境
