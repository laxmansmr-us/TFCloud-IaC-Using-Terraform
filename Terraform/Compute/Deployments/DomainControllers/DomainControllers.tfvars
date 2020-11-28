Environment       = "SharedServices"
CostCenter        = "12345"
ComputeRGName     = "DomainControllerRG"
ComputeRGLocation = "WestUS"

# Data Disks
// NumberOfDataDisks = 3
DataDisk-StorageAccountType = "Standard_LRS"
DataDisk-CreateOption       = "Empty"
DataDisk-DiskSizeGB         = 10


// NumberOfNICs = 1
NumberOfVMs                 = 1
VMName                      = "AZDC"
VMSize                      = "Standard_DS1_v2"
DeleteOSDiskOnTermination   = true
DeleteDataDiskOnTermination = true
ImagePublisher              = "MicrosoftWindowsServer"
ImageOffer                  = "WindowsServer"
ImageSKU                    = "2019-Datacenter"
ImageVersion                = "latest"
OSDiskCaching               = "ReadWrite"
OSDiskCreateOption          = "FromImage"
ManagedDiskType             = "Standard_LRS"
AdminUsername               = "TestAdmin"
AdminPassword               = "Password1234!12"
