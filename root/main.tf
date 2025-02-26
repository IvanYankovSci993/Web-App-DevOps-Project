# terraform/main.tf
# aks-terraform/main.tf


# terraform {
#   backend "azurerm" {
#     resource_group_name   = "my-resource-group"         # Replace with your resource group name
#     storage_account_name  = "storageaccountpractical"        # Replace with your storage account name
#     container_name        = "test"          # Replace with your container name
#     key                   = "terraform.tfstate"            # Specify the state file name
#   }
# }



# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
  client_id       = var.client_id           # appID
  client_secret   = var.client_secret #var.client_secret       # password
  subscription_id = "4f7ea576-9796-4381-8a3d-c19faee37af0"          # subscription ID az login --scope https://management.core.windows.net//.default   Use # 'az login --tenant TENANT_ID' to explicitly login to a tenant.       # 47d4542c-f112-47f4-92c7-a838d8a5e8ef 'AiCore Users'
  tenant_id       = "47d4542c-f112-47f4-92c7-a838d8a5e8ef"
}

module "networking" {
  source = "./networking-module"

  # Input variables for the networking module
  resource_group_name = "networking-rg"
  location            = "UK South"
  vnet_address_space  = ["10.0.0.0/16"]

  # Define more input variables as needed...
}

module "aks_cluster" {
  source = "./aks-cluster-module"

  # Input variables for the AKS cluster module
  aks_cluster_name           = "terraform-aks-cluster"
  cluster_location           = "UK South"
  dns_prefix                 = "myaks-project"
  kubernetes_version         = "1.26.6"  # Adjust the version as needed
  service_principal_client_id = var.client_id
  service_principal_client_secret = var.client_secret

  # Input variables referencing outputs from the networking module
  resource_group_name         = module.networking.resource_group_name
  vnet_id                     = module.networking.vnet_id
  control_plane_subnet_id     = module.networking.control_plane_subnet_id
  worker_node_subnet_id       = module.networking.worker_node_subnet_id
  aks_nsg_id                  = module.networking.aks_nsg_id

  # Define more input variables as needed...
}