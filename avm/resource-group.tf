module "resource-group" {
  source   = "Azure/avm-res-resources-resourcegroup/azurerm"
  version  = "0.1.0"
  location = var.location
  name     = "rg-azure-bridgehead"
}
