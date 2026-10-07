variable "name" {
  description = "Base name used to build resource names (e.g. gbs-dev)."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group in which the cluster is created."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "aks_subnet_id" {
  description = "ID of the subnet hosting the AKS nodes (and, with Azure CNI, the pods)."
  type        = string
}

variable "appgw_subnet_id" {
  description = "ID of the dedicated Application Gateway subnet. Set to null to disable the AGIC add-on."
  type        = string
  default     = null
}

variable "node_vm_size" {
  description = "VM size of the default node pool."
  type        = string
}

variable "node_count" {
  description = "Number of nodes in the default node pool."
  type        = number
  default     = 2
}

variable "service_cidr" {
  description = "Kubernetes service CIDR. Must not overlap with the virtual network."
  type        = string
  default     = "10.1.0.0/16"
}

variable "dns_service_ip" {
  description = "IP of the cluster DNS service. Must be inside service_cidr."
  type        = string
  default     = "10.1.0.10"
}

variable "tags" {
  description = "Tags applied to all resources."
  type        = map(string)
  default     = {}
}
