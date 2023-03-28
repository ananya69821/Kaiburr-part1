terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "Ananya-Org"

    workspaces {
      prefix = "starter-"
    }
  }
#   backend "local" {
    
#   }
  required_providers {

    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}

data "azurerm_client_config" "current" {

}
data "azuread_client_config" "current" {

}

resource "azurerm_resource_group" "this" {
  name     = "${var.env}-RGAKS01"
  location = var.location
  
}