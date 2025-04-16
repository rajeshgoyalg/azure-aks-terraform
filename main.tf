# Root Terraform configuration for Azure AKS (modular)

module "resource_group" {
  source  = "./modules/resource_group"
  name    = var.resource_group_name
  location = var.location
  tags    = var.tags
}

module "network" {
  source              = "./modules/network"
  vnet_name           = "aks-vnet-${var.aks_cluster_name}"
  address_space       = var.vnet_address_space
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name
  tags                = var.tags
  subnet_address_prefix = var.aks_subnet_address_prefix
}

module "identity" {
  source              = "./modules/identity"
  identity_name       = "aks-identity-${var.aks_cluster_name}"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  tags                = var.tags
}

module "aks" {
  source                     = "./modules/aks"
  aks_cluster_name           = var.aks_cluster_name
  location                   = module.resource_group.location
  resource_group_name        = module.resource_group.name
  dns_prefix                 = "${var.aks_cluster_name}-dns"
  kubernetes_version         = var.kubernetes_version
  tags                       = var.tags
  node_count                 = var.aks_node_count
  vm_size                    = var.aks_vm_size
  os_disk_size_gb            = 30
  subnet_id                  = module.network.subnet_id
  network_policy             = "azure"
  service_cidr               = "10.0.0.0/16"
  dns_service_ip             = "10.0.0.10"
  identity_type              = "SystemAssigned"
  # user_assigned_identity_id = module.identity.client_id # Uncomment if using UserAssigned
}
