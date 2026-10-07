variable "name" {
  description = "Base name used to build resource names (e.g. gbs-dev)."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group in which the VM is created."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "network_interface_id" {
  description = "ID of the network interface to attach to the VM."
  type        = string
}

variable "admin_username" {
  description = "Administrator username (SSH key authentication only)."
  type        = string
}

variable "ssh_public_key" {
  description = "SSH public key (file contents, not a path) for the administrator."
  type        = string
}

variable "vm_size" {
  description = "Size of the virtual machine."
  type        = string
}

variable "tags" {
  description = "Tags applied to all resources."
  type        = map(string)
  default     = {}
}
