# variables.tf

variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
  default     = "my-resource-group"
}

variable "location" {
  description = "The Azure region where the networking module will be deployed."
  type        = string
  default     = "UK South" 
}

variable "vnet_address_space" {
  description = "VNet address"
  type = list(string)
  default = ["10.0.0.0/16"]
}
