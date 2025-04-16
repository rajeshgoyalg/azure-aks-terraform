variable "aks_cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
}

variable "location" {
  description = "Azure region for the AKS cluster"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "dns_prefix" {
  description = "DNS prefix for the AKS cluster"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version for the AKS cluster"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to the AKS cluster"
  type        = map(string)
  default     = {}
}

variable "node_count" {
  description = "Number of nodes in the default node pool"
  type        = number
  default     = 2
}

variable "vm_size" {
  description = "VM size for the AKS nodes"
  type        = string
  default     = "Standard_B2ms"
}

variable "os_disk_size_gb" {
  description = "OS disk size in GB for AKS nodes"
  type        = number
  default     = 30
}

variable "subnet_id" {
  description = "Subnet resource ID for the node pool"
  type        = string
}

variable "network_policy" {
  description = "Network policy for AKS (azure or calico)"
  type        = string
  default     = "azure"
}

variable "service_cidr" {
  description = "Service CIDR for the AKS cluster"
  type        = string
  default     = "10.0.0.0/16"
}

variable "dns_service_ip" {
  description = "DNS service IP for the AKS cluster"
  type        = string
  default     = "10.0.0.10"
}

variable "identity_type" {
  description = "Type of identity to use (SystemAssigned or UserAssigned)"
  type        = string
  default     = "SystemAssigned"
}

# variable "user_assigned_identity_id" {
#   description = "ID of the user-assigned identity (if used)"
#   type        = string
#   default     = null
# }


variable "log_analytics_workspace_name" {
  description = "Name of the Log Analytics Workspace"
  type        = string
  default     = "law-aks"
}
