output "vnet_name" {
  description = "Virtual Network name"
  value       = azurerm_virtual_network.this.name
}

output "subnet_id" {
  description = "Subnet resource ID"
  value       = azurerm_subnet.aks_subnet.id
}
