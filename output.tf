output "subnetName" {
  value       = azurerm_subnet.sb.name
  description = "description"
}

output "PublicIP" {
  value       = azurerm_public_ip.IP.*.ip_address
  description = "My Public IP"
}