terraform {
  required_version = ">= 0.13"
  required_providers {
    azurerm = {
      # The "hashicorp" namespace is the new home for the HashiCorp-maintained
      # provider plugins.
      #
      # source is not required for the hashicorp/* namespace as a measure of
      # backward compatibility for commonly-used providers, but recommended for
      # explicitness.
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
        name = "TFCloud-IaC-tfm-ExpressRouteCircuitDeploy"
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

module "ER-Circuit" {
  source      = "../../../ExpressRoute/Circuit"
  Environment = "Global"
  CostCenter  = "0987654321"

  HubExpressRoute-RGName                 = var.HubExpressRoute-RGName
  HubExpressRoute-Location               = var.HubExpressRoute-Location
  HubExpressRoute-ServiceProviderName    = var.HubExpressRoute-ServiceProviderName
  HubExpressRoute-PeeringLocation        = var.HubExpressRoute-PeeringLocation
  HubExpressRoute-BandwidthInMBPS        = var.HubExpressRoute-BandwidthInMBPS
  HubExpressRoute-Tier                   = var.HubExpressRoute-Tier
  HubExpressRoute-Family                 = var.HubExpressRoute-Family
  HubExpressRoute-AllowClassicOperations = var.HubExpressRoute-AllowClassicOperations
}
