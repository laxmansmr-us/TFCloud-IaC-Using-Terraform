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
    organization = "vystmo-inc"

    # The name of the Terraform Cloud workspace to store Terraform state files in
    workspaces {
        name = "TFCloud-IaC-tfm-ExpressRoutePeeringDeploy"
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

module "ER-Peering" {
  source                     = "../../../ExpressRoute/Peering"
  ExpressRoute-PeeringType   = var.ExpressRoute-PeeringType
  ExpressRoute-CircuitName   = data.azurerm_express_route_circuit.HubExpressRoute.name
  ExpressRoute-RGName        = data.azurerm_express_route_circuit.HubExpressRoute.resource_group_name
  PeerASN                    = var.PeerASN
  PrimaryPeerAddressPrefix   = var.PrimaryPeerAddressPrefix
  SecondaryPeerAddressPrefix = var.SecondaryPeerAddressPrefix
  VLANID                     = var.VLANID
}
