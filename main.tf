terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "127e7a44-d802-42e4-b654-a434382666ac" # Azure for Students subscript ID
}

resource "azurerm_resource_group" "example" {
  name     = "example-rg"
  location = "East US"
  tags = {
    Environment = "Production"
    Owner       = "shaoxianduan"
  }
}

resource "azurerm_network_security_group" "example" {
  name                = "example-nsg"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  security_rule {
    name                       = "allow-ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "10.0.0.0/0" # Open rule, used to test policy failure
    destination_address_prefix = "*"
  }

  tags = {
    # Environment = "Production"
    # Owner       = "shaoxian"
  }
}