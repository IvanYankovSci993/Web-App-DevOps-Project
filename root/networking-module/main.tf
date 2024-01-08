# VNet codde from terraform registry
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network

resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name  #"example-resources"
  location = var.location             #"West Europe"
}

resource "azurerm_virtual_network" "example" {
  name                = "aks-vnet"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  address_space       = var.vnet_address_space
}

# Define subnets within the VNet for control plane and worker nodes
resource "azurerm_subnet" "control_plane_subnet" {
  name                 = "control-plane-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "worker_node_subnet" {
  name                 = "worker-node-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_security_group" "example" {
  name                = "aks-nsg"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  security_rule {
    #https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group
    name                       = "kube-apiserver-rule"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"    #allows traffic from any source to ...
    destination_port_range     = "443"   #allows traffic ... to port address 22
    source_address_prefix      = "90.202.231.182"    #allows traffic from any source to ...
    # (Optional) CIDR or source IP range or * to match any IP. Tags such as VirtualNetwork, AzureLoadBalancer and Internet can also be used. This is required if source_address_prefixes is not specified
    destination_address_prefix = "*"    #allows traffic from ... to any destination IP address 
    # (Optional) List of source address prefixes. Tags may not be used. This is required if source_address_prefix is not specified.
  }

  security_rule {
    #https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group
    name                       = "ssh-rule"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"    #allows traffic from any source to ...
    destination_port_range     = "22"   #allows traffic ... to port address 22
    source_address_prefix      = "90.202.231.182"    #allows traffic from any source to ...
    # (Optional) CIDR or source IP range or * to match any IP. Tags such as VirtualNetwork, AzureLoadBalancer and Internet can also be used. This is required if source_address_prefixes is not specified
    destination_address_prefix = "*"    #allows traffic from ... to any destination IP address 
    # (Optional) List of source address prefixes. Tags may not be used. This is required if source_address_prefix is not specified.
  }
}