output "subnet_id" {
  description = "The ID of the subnet"
  value       = azurerm_subnet.subnet.id
}
output "aks_subnet_id" {
  value = azurerm_subnet.aks_subnet.id
}

output "aks_nsg_id" {
  value = azurerm_network_security_group.aks_nsg.id
}
output "aks_public_ip_id" {
  description = "The ID of the public IP for AKS"
  value       = azurerm_public_ip.aks_public_ip.id
}

output "aks_public_ip_address" {
  description = "The public IP address of the AKS cluster"
  value       = azurerm_public_ip.aks_public_ip.ip_address
}
