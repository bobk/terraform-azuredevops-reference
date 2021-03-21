# this is the core HCL file for the reference example
# modules are built out in separate parallel dirs to represent different parts of the CAF examples
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=2.45.1"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rg-metadata"
    storage_account_name = "sametadata"
    container_name       = "terraformstate"
    key                  = "state.terraform-azuredevops-reference.prod"
  }
}

provider "azurerm" {
  features {
    #    key_vault {
    #      purge_soft_delete_on_destroy = true
    #    }
  }
}

module "lz-core" {
  source = "../../modules/lz-core/src"

  location = var.location
  suffix   = "lz${var.suffix}"
  tags     = var.tags
}

module "mgmt-core" {
  source = "../../modules/mgmt-core/src"

  location = var.location
  suffix   = "mgmt${var.suffix}"
  tags     = var.tags

  lalsa_ids = module.lz-core.sa_ids
}
