output "admin_username" {
  value = var.admin_username
}

output "admin_password" {
  sensitive = true
  value     = var.admin_password
}

output "firewall_ip" {
  value = azurerm_public_ip.ip-hub.ip_address
}