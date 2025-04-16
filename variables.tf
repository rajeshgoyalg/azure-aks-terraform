variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
  type        = string
  default     = "rg-aks-microservices-poc"
}

variable "location" {
  description = "Azure region where resources will be deployed"
  type        = string
  default     = "eastus"
}

variable "aks_cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
  default     = "aks-microservices-poc-cluster"
}

variable "vnet_address_space" {
  description = "Address space for the Virtual Network"
  type        = list(string)
  default     = ["10.10.0.0/16"]
}

variable "aks_subnet_address_prefix" {
  description = "Address prefix for the AKS subnet"
  type        = list(string)
  default     = ["10.10.1.0/24"]
}

variable "aks_node_count" {
  description = "Number of nodes in the default AKS node pool"
  type        = number
  default     = 2
}

variable "aks_vm_size" {
  description = "VM Size for the AKS nodes"
  type        = string
  default     = "Standard_B2ms"
}

variable "kubernetes_version" {
  description = "Specific Kubernetes version for AKS"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to Azure resources"
  type        = map(string)
  default = {
    environment = "poc"
    project     = "microservices-on-aks"
  }
}
