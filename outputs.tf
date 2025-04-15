output "resource_group_name" {
  description = "Name of the Azure Resource Group"
  value       = azurerm_resource_group.rg.name
}

output "aks_cluster_name" {
  description = "Name of the AKS cluster"
  value       = azurerm_kubernetes_cluster.aks.name
}

output "kube_config" {
  description = "Raw Kubernetes configuration for kubectl"
  value       = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive   = true # Mark as sensitive to prevent display in logs
}

# Optional: Output the cluster identity principal ID if needed for role assignments
output "aks_identity_principal_id" {
  description = "Principal ID of the System Assigned Managed Identity for the AKS cluster"
  value       = azurerm_kubernetes_cluster.aks.identity[0].principal_id
}
