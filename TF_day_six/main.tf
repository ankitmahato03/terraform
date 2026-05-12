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
  subscription_id = "00bf8343-a89e-4cdd-88fd-64f22cf7e1de"
}


resource "azurerm_resource_group" "local_azure_resource_roup" {
  name     = "RG-internal-POC-ankitm"
  location = "Central India"

} 

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "local_azure_virtual_Network" {
  name                = "azure_virtual_network"
  resource_group_name = azurerm_resource_group.local_azure_resource_roup.name
  location            = azurerm_resource_group.local_azure_resource_roup.location
  address_space       = ["10.0.0.0/24"]
}


resource "azurerm_subnet" "local_azure_subnet" {
  name                 = "subnet-poc"
  resource_group_name  = azurerm_resource_group.local_azure_resource_roup.name
  virtual_network_name = azurerm_virtual_network.local_azure_virtual_Network.name
  address_prefixes     = ["10.0.0.0/27"]
}


resource "azurerm_network_interface" "local_azure_network_interface" {
  resource_group_name = azurerm_resource_group.local_azure_resource_roup.name
  location            = azurerm_resource_group.local_azure_resource_roup.location
  name                = "azure-virtual-machine-POC-nic"
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.local_azure_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_public_ip.id
  }

}


resource "azurerm_public_ip" "vm_public_ip" {
  name                = "vm-public-ip"
  resource_group_name = azurerm_resource_group.local_azure_resource_roup.name
  location            = azurerm_resource_group.local_azure_resource_roup.location

  allocation_method = "Static"
  sku               = "Standard"
}


resource "azurerm_network_security_group" "vm_nsg" {
  name                = "vm-ssh-nsg"
  location            = azurerm_resource_group.local_azure_resource_roup.location
  resource_group_name = azurerm_resource_group.local_azure_resource_roup.name

  security_rule {
    name                       = "Allow-SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "subnet_nsg_assoc" {
  subnet_id                 = azurerm_subnet.local_azure_subnet.id
  network_security_group_id = azurerm_network_security_group.vm_nsg.id
}


resource "azurerm_linux_virtual_machine" "local_azure_virtual_Mechine" {
  resource_group_name = azurerm_resource_group.local_azure_resource_roup.name
  location            = azurerm_resource_group.local_azure_resource_roup.location
  size                = "Standard_B1s"
  admin_username      = "azureuser"
  name                = "azure-virtual-machine-POC"

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  

  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/id_ed25519.pub")
  }




  network_interface_ids = [azurerm_network_interface.local_azure_network_interface.id]

}




# storage account 

resource "azurerm_storage_account" "storage_account_local" {
  for_each = var.storage_account_name
  resource_group_name = azurerm_resource_group.local_azure_resource_roup.name
  location= azurerm_resource_group.local_azure_resource_roup.location
  account_replication_type = "LRS"
  account_tier = "Standard"
  name = each.value
}