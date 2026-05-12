terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.67.0"
    }
  }
  required_version = ">=1.9.0"
}


provider "azurerm"{
  features {}
  subscription_id = var.client_secret 
}


resource "azurerm_resource_group" "local_azure_resource_roup" {
  name     = "RG-internal-POC-ankit-mahato"
  location = "Central India"

} 

# Create a NSG  
resource "azurerm_network_security_group" "azure_nsg" {
  name = "azure_network_security_Group"
  location = azurerm_resource_group.local_azure_resource_roup.location
  resource_group_name = azurerm_resource_group.local_azure_resource_roup.name

  #Dynamic Block
  dynamic "security_rule" {
    for_each = local.nsg_rules
    content {
      name = security_rule.key
      priority = security_rule.value.priority
      direction = "Inbound"
      access = "Allow"
      protocol = "Tcp"
      source_port_range = "*"
      destination_port_range = security_rule.value.destination_port_range
      source_address_prefix = "*"
      destination_address_prefix = "*"
      description = security_rule.value.description 
    }
  }


}