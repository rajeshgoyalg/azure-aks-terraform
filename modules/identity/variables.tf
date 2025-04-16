variable "identity_name" {
  description = "Name of the user-assigned managed identity"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name for the identity"
  type        = string
}

variable "location" {
  description = "Azure region for the identity"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the identity"
  type        = map(string)
  default     = {}
}
