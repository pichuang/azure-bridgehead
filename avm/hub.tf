module "hub" {
  source              = "Azure/avm-res-network-virtualnetwork/azurerm"
  version             = "0.4.2"
  location            = var.location
  resource_group_name = module.resource-group.name
  address_space       = ["10.99.98.0/23"]
  subnets = {
    snet-azfw = {
      name = "AzureFirewallSubnet"
      address_prefixes = ["10.99.98.0/26"]
      route_table = {
        id = module.rt-azfw.resource_id
      }
    }
    snet-azfw-mgmt = {
      name = "AzureFirewallManagementSubnet"
      address_prefixes = ["10.99.98.64/26"]
    }
    snet-ars = {
      name = "RouteserverSubnet"
      address_prefixes = ["10.99.98.128/27"]
    }
    snet-vgw = {
      name = "GatewaySubnet"
      address_prefixes = ["10.99.98.160/27"]
      route_table = {
        id = module.rt-vgw.resource_id
      }
    }
    snet-bastion = {
      name = "AzureBastionSubnet"
      address_prefixes = ["10.99.98.192/26"]
    }
    snet-vm1 = {
      name = "snet-vm1"
      address_prefixes = ["10.99.99.0/25"]
    }
    snet-vm2 = {
      name = "snet-vm2"
      address_prefixes = ["10.99.99.128/25"]
    }
  }
  depends_on = [
    module.resource-group,
    module.rt-azfw
  ]
}

module "rt-azfw" {
  source              = "Azure/avm-res-network-routetable/azurerm"
  version             = "0.2.2"
  location            = var.location
  resource_group_name = module.resource-group.name
  disable_bgp_route_propagation = false
  name = "rt-azfw"
  routes = {
    default-route = {
      name = "default-route"
      address_prefix = "0.0.0.0/0"
      next_hop_type = "Internet"
    }
  }
  subnet_resource_ids = {
    snet-azfw = module.hub.subnets["snet-azfw"].resource_id
  }
}

module "rt-vgw" {
  source              = "Azure/avm-res-network-routetable/azurerm"
  version             = "0.2.2"
  location            = var.location
  resource_group_name = module.resource-group.name
  disable_bgp_route_propagation = false
  name = "rt-vgw"
  subnet_resource_ids = {
    snet-vgw = module.hub.subnets["snet-vgw"].resource_id
  }
}
