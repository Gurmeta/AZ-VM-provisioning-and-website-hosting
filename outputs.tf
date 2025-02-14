output "vm_id" {
  description = "The ID of the Virtual Machine"
  value       = module.compute.vm_id
}

output "vm_public_ip" {
  description = "The public IP address of the Virtual Machine"
  value       = module.network.vm_public_ip
}

output "aks_public_ip_id" {
  description = "The ID of the public IP for the AKS cluster"
  value       = module.network.aks_public_ip_id
}

output "aks_public_ip_address" {
  description = "The public IP address assigned to the AKS cluster"
  value       = module.network.aks_public_ip_address
}
