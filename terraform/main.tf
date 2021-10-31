terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.83.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "cs16" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_container_group" "cs16" {
  name                = var.container_group_name
  location            = azurerm_resource_group.cs16.location
  resource_group_name = azurerm_resource_group.cs16.name
  ip_address_type     = "public"
  os_type             = "linux"

  container {
    name   = var.container_name
    image  = var.container_image
    cpu    = var.container_cpu
    memory = var.container_memory

    ports {
      port     = 27015
      protocol = "UDP"
    }

    ports {
      port     = 27020
      protocol = "UDP"
    }

    ports {
      port     = 26900
      protocol = "UDP"
    }

    environment_variables = {
      "SERVER_NAME" = var.env_server_name
      "MAP"         = var.env_map
      "MAXPLAYERS"  = var.env_maxplayers
    }

    secure_environment_variables = {
      "ADMIN_STEAM"   = var.env_admin_steam
      "SV_PASSWORD"   = var.env_sv_password
      "RCON_PASSWORD" = var.env_rcon_password
    }
  }
}
