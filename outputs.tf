output "resource_group_name" {
  description = "Name of the resource group."
  value       = azurerm_resource_group.rg.name
}

output "vm_id" {
  description = "The ID of the virtual machine."
  value       = module.compute.vm_id
}

output "vm_public_ip" {
  description = "The public IP address of the virtual machine."
  value       = module.network.vm_public_ip
}

output "ssh_command" {
  description = "Command to connect to the virtual machine."
  value       = "ssh ${var.admin_username}@${module.network.vm_public_ip}"
}

output "aks_cluster_id" {
  description = "The ID of the AKS cluster."
  value       = module.aks.aks_cluster_id
}

output "aks_cluster_name" {
  description = "The name of the AKS cluster (use with `az aks get-credentials`)."
  value       = module.aks.aks_cluster_name
}
