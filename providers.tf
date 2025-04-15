provider "azurerm" {
  features {}
  # The Azure CLI login session will be used for authentication by default.
  # You can explicitly configure subscription_id if needed:
  subscription_id = "5dbc091b-6607-4662-b21f-f231bd2df54d"
  resource_provider_registrations = "none"
}
