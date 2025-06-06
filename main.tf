terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.116.0"
    }
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true

  # 提供虚假凭证以绕过 Azure CLI 认证
  client_id     = "00000000-0000-0000-0000-000000000000"
  client_secret = "dummy-secret"
  tenant_id     = "00000000-0000-0000-0000-000000000000"
  subscription_id = "00000000-0000-0000-0000-000000000000"
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
    source_address_prefix      = "10.0.0.0/16"
    destination_address_prefix = "*"
  }

  tags = {
    Environment = "Production"
    Owner       = "shaoxianduan"
  }
}