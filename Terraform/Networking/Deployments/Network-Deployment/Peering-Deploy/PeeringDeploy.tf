terraform {
  required_version = ">= 0.13"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.0.0"
    }
  }
  # Backend for configuring remote state files to use Terraform Cloud (TFC)
  backend "remote" {
    # The name of your Terraform Cloud organization.
    organization = "AdinErmie"

    # The name of the Terraform Cloud workspace to store Terraform state files in
    workspaces {
        name = "TFCloud-IaC-tfm-PeeringDeploy"
    }
  }
}

provider "azurerm" {
  features {}
/**
  #(Optional) The Subscription ID which should be used. This can also be sourced from the ARM_SUBSCRIPTION_ID Environment Variable.
  subscription_id = var.subscription_id
  #(Optional) The Client ID which should be used. This can also be sourced from the ARM_CLIENT_ID Environment Variable.
  client_id       = var.client_id
  client_secret   = var.client_secret
  #(Optional) The Tenant ID which should be used. This can also be sourced from the ARM_TENANT_ID Environment Variable.
  tenant_id       = var.tenant_id
  #(Optional) The Cloud Environment which should be used. Possible values are public, usgovernment, german and china. Defaults to public. This can also be sourced from the ARM_ENVIRONMENT environment variable.
**/
environment = "public"
}

module "VNET-Peering" {
  source                        = "../../../VNetPeering"
  HubVNet-RGName                = data.azurerm_virtual_network.SharedServicesVNET.resource_group_name
  HubVNet-Name                  = data.azurerm_virtual_network.SharedServicesVNET.name
  HubNetwork-ID                 = data.azurerm_virtual_network.SharedServicesVNET.id
  HubVNet-AllowVNetAccess       = var.HubVNet-AllowVNetAccess
  HubVNet-AllowForwardedTraffic = var.HubVNet-AllowForwardedTraffic
  HubVNet-AllowGatewayTransit   = var.HubVNet-AllowGatewayTransit
  // depends_on = [
  //   module.vnets-SharedServices, module.vnets-Prod
  // ]

  ProdVNet-RGName                = data.azurerm_virtual_network.ProdVNET.resource_group_name
  ProdVNet-Name                  = data.azurerm_virtual_network.ProdVNET.name
  ProdNetwork-ID                 = data.azurerm_virtual_network.ProdVNET.id
  ProdVNet-AllowVNetAccess       = var.ProdVNet-AllowVNetAccess
  ProdVNet-AllowForwardedTraffic = var.ProdVNet-AllowForwardedTraffic
  ProdVNet-AllowGatewayTransit   = var.ProdVNet-AllowGatewayTransit

  NonProdVNet-RGName                = data.azurerm_virtual_network.NonProdVNET.resource_group_name
  NonProdVNet-Name                  = data.azurerm_virtual_network.NonProdVNET.name
  NonProdNetwork-ID                 = data.azurerm_virtual_network.NonProdVNET.id
  NonProdVNet-AllowVNetAccess       = var.NonProdVNet-AllowVNetAccess
  NonProdVNet-AllowForwardedTraffic = var.NonProdVNet-AllowForwardedTraffic
  NonProdVNet-AllowGatewayTransit   = var.NonProdVNet-AllowGatewayTransit
}
