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
        name = "TFCloud-IaC-tfm-HubDeploy"
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

module "vnets-SharedServices" {
  source      = "../../../Hub/"
  Environment = "SharedServices"
  CostCenter  = "12345"

  SharedServicesResourceGroupLocation                 = var.SharedServicesResourceGroupLocation
  SharedServices-VNet-AddressSpace                    = var.SharedServices-VNet-AddressSpace
  SharedServices-GatewaySubnet-AddressPrefix          = var.SharedServices-GatewaySubnet-AddressPrefix
  SharedServices-DomainControllerSubnet-AddressPrefix = var.SharedServices-DomainControllerSubnet-AddressPrefix
  SharedServices-AzureFirewallSubnet-AddressPrefix    = var.SharedServices-AzureFirewallSubnet-AddressPrefix

  EnableVPNGateway = var.EnableVPNGateway
  EnableERGateway  = var.EnableERGateway
  EnableAFW  = var.EnableAFW

  Hub-VPNGateway-ActiveActiveEnabled = var.Hub-VPNGateway-ActiveActiveEnabled
  Hub-ERGateway-ActiveActiveEnabled  = var.Hub-ERGateway-ActiveActiveEnabled

  Hub-VPNGateway-BGPEnabled = var.Hub-VPNGateway-BGPEnabled
  Hub-ERGateway-BGPEnabled  = var.Hub-ERGateway-BGPEnabled

  Hub-ERGateway-SKU  = var.Hub-ERGateway-SKU
  Hub-VPNGateway-SKU = var.Hub-VPNGateway-SKU

  AFWPIP-AllocationMethod = var.AFWPIP-AllocationMethod
  AFWPIP-SKU              = var.AFWPIP-SKU
}
