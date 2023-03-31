# https://blog.pichuang.com.tw/azure-subnets.html

resource "azurerm_virtual_network" "vnet-bridgehead" {
  address_space       = ["10.99.98.0/23"]
  location            = var.lab-location
  name                = "vnet-bridgehead"
  resource_group_name = var.lab-rg
  tags                = var.tags

  depends_on = [
    azurerm_resource_group.resource-group
  ]
}

resource "azurerm_subnet" "azurefirewallsubnet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = var.lab-rg
  virtual_network_name = azurerm_virtual_network.vnet-bridgehead.name
  address_prefixes     = ["10.99.98.0/26"]

  depends_on = [
    azurerm_virtual_network.vnet-bridgehead
  ]
}

resource "azurerm_subnet" "azurefirewallmanagementsubnet" {
  name                 = "AzureFirewallManagementSubnet"
  resource_group_name  = var.lab-rg
  virtual_network_name = azurerm_virtual_network.vnet-bridgehead.name
  address_prefixes     = ["10.99.98.64/26"]

  depends_on = [
    azurerm_virtual_network.vnet-bridgehead
  ]
}

resource "azurerm_subnet" "routeserversubnet" {
  name                 = "RouteServerSubnet"
  resource_group_name  = var.lab-rg
  virtual_network_name = azurerm_virtual_network.vnet-bridgehead.name
  address_prefixes     = ["10.99.98.128/27"]

  depends_on = [
    azurerm_virtual_network.vnet-bridgehead
  ]
}

resource "azurerm_subnet" "gatewaysubnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = var.lab-rg
  virtual_network_name = azurerm_virtual_network.vnet-bridgehead.name
  address_prefixes     = ["10.99.98.160/27"]

  depends_on = [
    azurerm_virtual_network.vnet-bridgehead
  ]
}

resource "azurerm_subnet" "azurebastionsubnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = var.lab-rg
  virtual_network_name = azurerm_virtual_network.vnet-bridgehead.name
  address_prefixes     = ["10.99.98.192/26"]

  depends_on = [
    azurerm_virtual_network.vnet-bridgehead
  ]
}

resource "azurerm_subnet" "subnet-hub" {
  name                 = "subnet-hub"
  resource_group_name  = var.lab-rg
  virtual_network_name = azurerm_virtual_network.vnet-bridgehead.name
  address_prefixes     = ["10.99.99.0/24"]

  depends_on = [
    azurerm_virtual_network.vnet-bridgehead
  ]
}

#
# Create Route Table
#

resource "azurerm_route_table" "rt-for-fw" {
  name                          = "rt-for-fw"
  location                      = var.lab-location
  resource_group_name           = var.lab-rg
  disable_bgp_route_propagation = false

  route {
    name           = "route-to-internet"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "Internet"
  }

  depends_on = [
    azurerm_resource_group.resource-group
  ]
}

resource "azurerm_subnet_route_table_association" "associate-rt-to-fw-and-azurefirewallsubnet" {
  subnet_id      = azurerm_subnet.azurefirewallsubnet.id
  route_table_id = azurerm_route_table.rt-for-fw.id

  depends_on = [
    azurerm_firewall.firewall
  ]
}

resource "azurerm_route_table" "rt-for-subnet" {
  name                          = "rt-for-subnet"
  location                      = var.lab-location
  resource_group_name           = var.lab-rg
  disable_bgp_route_propagation = false

  route {
    name           = "route-to-azfw"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.firewall.ip_configuration[0].private_ip_address
  }

  depends_on = [
    azurerm_resource_group.resource-group
  ]
}

resource "azurerm_subnet_route_table_association" "associate-rt-to-subnet-and-subnet" {
  subnet_id      = azurerm_subnet.subnet-hub.id
  route_table_id = azurerm_route_table.rt-for-subnet.id

  depends_on = [
    azurerm_firewall.firewall
  ]
}

#
# Create a VM in the subnet-hub
#

# Create network interface card
resource "azurerm_network_interface" "nic-hub" {
  name                = "nic-hub"
  location            = var.lab-location
  resource_group_name = var.lab-rg

  ip_configuration {
    name                          = "ipconfig-nic-hub"
    subnet_id                     = azurerm_subnet.subnet-hub.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.99.99.4"
  }
}

resource "azurerm_linux_virtual_machine" "vm-hub" {
  name                  = "vm-hub"
  location              = var.lab-location
  resource_group_name   = var.lab-rg
  network_interface_ids = [azurerm_network_interface.nic-hub.id]
  size                  = "Standard_DC2s_v3"

  os_disk {
    name                 = "disk-vm-hub"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-minimal-jammy"
    sku       = "minimal-22_04-lts-gen2"
    version   = "latest"
  }

  computer_name                   = "vm-hub"
  admin_username                  = var.admin_username
  disable_password_authentication = false
  admin_password                  = var.admin_password

  admin_ssh_key {
    username   = var.admin_username
    public_key = file("~/.ssh/azure-rsa.pub")
  }

  custom_data = filebase64("cloud-init.txt")

}
