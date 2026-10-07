variable "name" {
  description = "Base name used to build resource names (e.g. gbs-dev)."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group in which the network resources are created."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "address_space" {
  description = "Address space of the virtual network."
  type        = list(string)
}

variable "vm_subnet_prefix" {
  description = "Address prefix of the VM subnet."
  type        = list(string)
}

variable "aks_subnet_prefix" {
  description = "Address prefix of the AKS node subnet."
  type        = list(string)
}

variable "appgw_subnet_prefix" {
  description = "Address prefix of the Application Gateway subnet."
  type        = list(string)
}

variable "enable_appgw_subnet" {
  description = "Create the dedicated Application Gateway subnet."
  type        = bool
  default     = true
}

variable "allowed_ssh_cidrs" {
  description = "CIDR blocks allowed to connect to the VM over SSH."
  type        = list(string)
}

variable "aks_allowed_inbound_ports" {
  description = "TCP ports allowed inbound on the AKS subnet."
  type        = list(number)
  default     = [80, 443]
}

variable "tags" {
  description = "Tags applied to all resources."
  type        = map(string)
  default     = {}
}
