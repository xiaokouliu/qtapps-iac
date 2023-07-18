# 本地Kubernetes示例

## 准备工作

1. 已经安装Kubernetes命令行工具。
2. `KUBECONFIG`环境变量已正确设置。可以使用`echo $KUBECONFIG`命令检查。
3. 已经使用`kubectl`命令行工具连接到了本地Kubernetes集群。可以使用`kubectl cluster-info`命令检查。

## 配置

在`provider.tf`文件的`provider "kubernetes"`部分配置本地集群。其中：

1. `config_path`参数是本地Kubernetes配置文件的路径，在Windows系统下应该换成合适的目录。
2. `config_context`参数必须与本地Kubernetes集群的名称相匹配。可以运行`kubectl config get-contexts`命令查看本地Kubernetes集群的名称。
