variable "vault_namespace" {
    default = "default"
}

variable "vault_service_type" {
    # 使用集群节点的IP地址和一个固定的端口映射到Service的端口
    # 本地用以调试
    default = "NodePort"
    # 用于在云服务中部署到公网访问
    # 本地不可用。
    # default = "LoadBalancer"
}
