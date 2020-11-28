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
        name = "TFCloud-IaC-tfm-ExpressRouteConnectionDeploy"
    }
  }
}

provider "azurerm" {
  features {}
  #(Optional) The Subscription ID which should be used. This can also be sourced from the ARM_SUBSCRIPTION_ID Environment Variable.
  subscription_id = var.subscription_id
  #(Optional) The Client ID which should be used. This can also be sourced from the ARM_CLIENT_ID Environment Variable.
  client_id       = var.client_id
  client_secret   = var.client_secret
  #(Optional) The Tenant ID which should be used. This can also be sourced from the ARM_TENANT_ID Environment Variable.
  tenant_id       = var.tenant_id
  #(Optional) The Cloud Environment which should be used. Possible values are public, usgovernment, german and china. Defaults to public. This can also be sourced from the ARM_ENVIRONMENT environment variable.
  environment = "public"
}

module "ER-Connection" {
  source      = "../../../ExpressRoute/Connection"
  Environment = "Global"
  CostCenter  = "0987654321"

  HubExpressRoute-PeeringLocation = var.HubExpressRoute-PeeringLocation
  ConnectionType                  = var.ConnectionType
  RouteWeight                     = var.RouteWeight
  EnableBGP                       = var.EnableBGP
  ExpressRoute-GatewayBypass      = var.ExpressRoute-GatewayBypass
  UsePolicyBasedTrafficSelectors  = var.UsePolicyBasedTrafficSelectors

  Hub-ExpressRouteCircuit-Name    = data.azurerm_express_route_circuit.HubExpressRoute.name
  Hub-ExpressRouteCircuit-RGName  = data.azurerm_express_route_circuit.HubExpressRoute.resource_group_name
  Hub-ERGateway-Name              = data.azurerm_virtual_network_gateway.HubExpressRoute-Gateway.name
  HubExpressRoute-GatewayLocation = data.azurerm_virtual_network_gateway.HubExpressRoute-Gateway.location
  Hub-ERGateway-RGName            = data.azurerm_virtual_network_gateway.HubExpressRoute-Gateway.resource_group_name

  HubExpressRoute-GatewayID      = data.azurerm_virtual_network_gateway.HubExpressRoute-Gateway.id
  HubExpressRoute-ExpressRouteID = data.azurerm_express_route_circuit.HubExpressRoute.id
}
