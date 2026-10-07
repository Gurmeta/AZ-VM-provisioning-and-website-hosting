output "vm_subnet_id" {
  description = "The ID of the VM subnet."
  value       = azurerm_subnet.vm.id
}

output "aks_subnet_id" {
  description = "The ID of the AKS node subnet."
  value       = azurerm_subnet.aks.id
}

output "appgw_subnet_id" {
  description = "The ID of the Application Gateway subnet, or null when disabled."
  value       = one(azurerm_subnet.appgw[*].id)
}

output "aks_nsg_id" {
  description = "The ID of the AKS subnet network security group."
  value       = azurerm_network_security_group.aks.id
}

output "network_interface_id" {
  description = "The ID of the VM network interface."
  value       = azurerm_network_interface.nic.id
}

output "vm_public_ip" {
  description = "The public IP address of the virtual machine."
  value       = azurerm_public_ip.vm.ip_address
}
