#
# Azure Firewall
#

resource "azurerm_public_ip" "pip-fw" {
  name                = "pip-fw"
  location            = var.lab-location
  resource_group_name = var.lab-rg
  allocation_method   = "Static"
  sku                 = "Standard"

  depends_on = [
    azurerm_resource_group.resource-group
  ]
}

resource "azurerm_firewall" "firewall" {
  name                = "firewall"
  location            = var.lab-location
  resource_group_name = var.lab-rg
  sku_name            = "AZFW_VNet"
  sku_tier            = "Basic"

  ip_configuration {
    name                 = "fw-1-config"
    subnet_id            = azurerm_subnet.azurefirewallsubnet.id
    public_ip_address_id = azurerm_public_ip.pip-fw.id
  }

  firewall_policy_id = azurerm_firewall_policy.firewall-policy-for-bridgehead.id

  depends_on = [
    azurerm_firewall_policy.firewall-policy-for-bridgehead
  ]

}

resource "azurerm_firewall_policy" "firewall-policy-for-bridgehead" {
  name                = "bridgehead-firewall-policy"
  resource_group_name = var.lab-rg
  location            = var.lab-location
  sku                 = "Basic"

  threat_intelligence_mode = "Alert"

  # IDPS is available only for premium policies
  # intrusion_detection {
  #   mode = "Alert"
  # }

  base_policy_id = null

  dns {
    servers       = null
    proxy_enabled = false
  }

}

resource "azurerm_firewall_policy_rule_collection_group" "fprcg-for-bridgehead" {
  name               = "fprcg-for-bridgehead"
  firewall_policy_id = azurerm_firewall_policy.firewall-policy-for-bridgehead.id
  priority           = 65000

  network_rule_collection {
    name     = "network-rule-collection-for-bridgehead"
    priority = 200
    action   = "Allow"

    rule {
      name                  = "network-rule-icmp-any-to-any"
      protocols             = ["ICMP"]
      source_addresses      = ["*"]
      destination_addresses = ["*"]
      destination_ports     = ["*"]
    }
  }

  nat_rule_collection {
    name     = "nat-rule-collection-for-bridgehead"
    priority = 100
    action   = "Dnat"

    rule {
      name                  = "ssh-internet-to-vm"
      protocols             = ["TCP"]
      source_addresses      = ["*"]
      destination_addresses = azurerm_public_ip.pip-fw.ip_address
      destination_ports     = ["5566"]
      translated_address    = "10.99.99.4"
      translated_port       = "22"
  }

  depends_on = [
    azurerm_firewall_policy.firewall-policy-for-bridgehead
  ]

}
