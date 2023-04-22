terraform {

  required_version = ">= 1.0.0"

  required_providers {

    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }

#teste de atualizacao
 

  backend "azurerm" {

    resource_group_name  = "remote-states"
    storage_account_name = "mmondiniremotestates"
    container_name       = "remotestates"
    key                  = "pipeline-gitlab-ci/terraform.tfstate"
  }


}

provider "azurerm" {
  features {}

}

data "terraform_remote_state" "vnet" {
  backend = "azurerm"
  config = {
    resource_group_name  = "remote-states"
    storage_account_name = "mmondiniremotestates"
    container_name       = "remotestates"
    key                  = "azure-vnet/terraform.tfstate"
  }
}

provider "aws" {
  region = "sa-east-1"

  default_tags {
    tags = {
      owner      = "mmondinii"
      managed-by = "terraform"
    }
  }
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "mmondinii-remote-states"
    key    = "aws-vpc/terraform.tfstates"
    region = "sa-east-1"
  }
}
