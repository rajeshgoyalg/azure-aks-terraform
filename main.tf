resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_virtual_network" "vnet" {
  name                = "aks-vnet-${var.aks_cluster_name}"
  address_space       = var.vnet_address_space
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.tags
}

resource "azurerm_subnet" "aks_subnet" {
  name                 = "aks-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.aks_subnet_address_prefix
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_cluster_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "${var.aks_cluster_name}-dns" # Must be unique across Azure
  tags                = var.tags
  kubernetes_version  = var.kubernetes_version # null lets Azure choose latest stable

  default_node_pool {
    name            = "default"
    node_count      = var.aks_node_count
    vm_size         = var.aks_vm_size
    os_disk_size_gb = 30
    vnet_subnet_id  = azurerm_subnet.aks_subnet.id
    tags            = var.tags
    # Enable auto-scaling if desired
    # enable_auto_scaling = true
    # min_count           = 1
    # max_count           = 3
  }

  # Configure Azure CNI networking for enhanced integration and functionality
  network_profile {
    network_plugin     = "azure"
    network_policy     = "azure" # Or "calico" if needed
    load_balancer_sku  = "standard" # Recommended over basic
    # These CIDRs must not overlap with VNet/Subnet or other networks
    service_cidr       = "10.0.0.0/16"
    dns_service_ip     = "10.0.0.10"
  }

  # Use System Assigned Managed Identity for simplicity
  # This identity allows AKS to interact with other Azure resources (like ACR, Load Balancers)
  identity {
    type = "SystemAssigned"
  }

  # Optional: Enable Azure AD integration for user authentication (more complex setup)
  # azure_active_directory_role_based_access_control {
  #   managed            = true
  #   azure_rbac_enabled = true # Use Azure RBAC for Kubernetes authorization
  #   admin_group_object_ids = ["<your-aad-admin-group-object-id>"] # Group for cluster admins
  # }

  # Optional: Enable Azure Monitor for containers
  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id # Requires Log Analytics Workspace
  }

  # Add-on profiles can enable features like AGIC, Monitoring, etc.
  # addon_profile {
  #   oms_agent { # Equivalent to the oms_agent block above
  #     enabled                    = true
  #     log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id
  #   }
  #   # Example for Azure Policy
  #   # azure_policy {
  #   #  enabled = true
  #   # }
  # }
}

# Optional: Create Log Analytics Workspace for Monitoring
resource "azurerm_log_analytics_workspace" "law" {
  name                = "law-${var.aks_cluster_name}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018" # Standard pricing tier
  retention_in_days   = 30
  tags                = var.tags
}

# Optional: Enable Container Insights solution on the workspace
resource "azurerm_log_analytics_solution" "container_insights" {
  solution_name         = "ContainerInsights"
  location              = azurerm_log_analytics_workspace.law.location
  resource_group_name   = azurerm_log_analytics_workspace.law.resource_group_name
  workspace_resource_id = azurerm_log_analytics_workspace.law.id
  workspace_name        = azurerm_log_analytics_workspace.law.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }
}
