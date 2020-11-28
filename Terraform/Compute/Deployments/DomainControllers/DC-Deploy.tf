provider "azurerm" {
  # alias = "ShdSvc"
/**
  version = ">=1.38.0"
  //   subscription_id = ""
  #(Optional) The Subscription ID which should be used. This can also be sourced from the ARM_SUBSCRIPTION_ID Environment Variable.

  //   client_id = ""
  #(Optional) The Client ID which should be used. This can also be sourced from the ARM_CLIENT_ID Environment Variable.
  //   client_secret = ""
  //   tenant_id     = ""
  #(Optional) The Tenant ID which should be used. This can also be sourced from the ARM_TENANT_ID Environment Variable.
**/
  environment = "public"
  #(Optional) The Cloud Environment which should be used. Possible values are public, usgovernment, german and china. Defaults to public. This can also be sourced from the ARM_ENVIRONMENT environment variable.
}

# Allows what version of Terraform to use.
terraform {
  required_version = ">=0.12.0"
  # Backend for configuring remote state files to Azure Storage
  backend "remote" {
    organization = "vystmo-inc"
    workspaces {
      name = "TFCloud-IaC-tfm-DomainControllerDeploy"
    }
  }
}

resource "azurerm_resource_group" "ComputeRG" {
  name     = var.ComputeRGName
  location = var.ComputeRGLocation
  tags = {
    Environment = var.Environment
    CostCenter  = var.CostCenter
  }
}

module "NIC" {
  source = "../../NIC/"

  Environment = var.Environment
  CostCenter  = var.CostCenter
  // NumberOfNICs = var.NumberOfNICs

  ComputeRGName     = azurerm_resource_group.ComputeRG.name
  ComputeRGLocation = azurerm_resource_group.ComputeRG.location

  VMName      = var.VMName
  NumberOfVMs = var.NumberOfVMs
  SubnetID    = data.azurerm_subnet.DomainControllerSubnet.id
}

module "DataDisks" {
  source = "../../Disk/DataDisk/"

  Environment = var.Environment
  CostCenter  = var.CostCenter
  // NumberOfDataDisks = var.NumberOfDataDisks

  ComputeRGName     = azurerm_resource_group.ComputeRG.name
  ComputeRGLocation = azurerm_resource_group.ComputeRG.location

  VMName                      = var.VMName
  NumberOfVMs                 = var.NumberOfVMs
  DataDisk-StorageAccountType = var.DataDisk-StorageAccountType
  DataDisk-CreateOption       = var.DataDisk-CreateOption
  DataDisk-DiskSizeGB         = var.DataDisk-DiskSizeGB
}

module "VMs" {
  source = "../../VM/"

  Environment = var.Environment
  CostCenter  = var.CostCenter

  ComputeRGName     = azurerm_resource_group.ComputeRG.name
  ComputeRGLocation = azurerm_resource_group.ComputeRG.location

  VMName      = var.VMName
  NumberOfVMs = var.NumberOfVMs

  NIC-ID = module.NIC.NIC-IDs[0]
  VMSize = var.VMSize

  DeleteOSDiskOnTermination   = var.DeleteOSDiskOnTermination
  DeleteDataDiskOnTermination = var.DeleteDataDiskOnTermination

  ImagePublisher = var.ImagePublisher
  ImageOffer     = var.ImageOffer
  ImageSKU       = var.ImageSKU
  ImageVersion   = var.ImageVersion

  OSDiskCaching      = var.OSDiskCaching
  OSDiskCreateOption = var.OSDiskCreateOption
  ManagedDiskType    = var.ManagedDiskType

  AdminUsername = var.AdminUsername
  AdminPassword = var.AdminPassword
}
