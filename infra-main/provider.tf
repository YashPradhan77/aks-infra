terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.16"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.49.0"
    }
    # backend "azurerm" { 
    # resource_group_name = "tfstate" 
    # storage_account_name = "<storage_account_name>" 
    # container_name = "tfstate" # key = "terraform.tfstate" # 
    #}
  }

  required_version = ">= 1.8.0"
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  resource_provider_registrations = "none"
}

provider "azuread" {}