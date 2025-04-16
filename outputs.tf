output "resource_group_name" {
  description = "Name of the Azure Resource Group"
  value       = module.resource_group.name
}

output "aks_cluster_name" {
  description = "Name of the AKS cluster"
  value       = module.aks.aks_cluster_name
}

output "kube_config" {
  description = "Raw Kubernetes configuration for kubectl"
  value       = module.aks.kube_config
  sensitive   = true
}

output "aks_identity_principal_id" {
  description = "Principal ID of the Managed Identity for the AKS cluster"
  value       = module.aks.principal_id
}
