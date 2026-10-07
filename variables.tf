variable "resource_group_name" {
  description = "Name of the resource group that holds all resources."
  type        = string
  default     = "gbs-dev-rg"
}

variable "location" {
  description = "Azure region for all resources."
  type        = string
  default     = "westeurope"
}

variable "name_prefix" {
  description = "Short prefix used to name every resource (lowercase letters, digits, hyphens)."
  type        = string
  default     = "gbs"

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{1,11}$", var.name_prefix))
    error_message = "name_prefix must be 2-12 characters, start with a letter and contain only lowercase letters, digits or hyphens."
  }
}

variable "environment" {
  description = "Environment name, used in resource names and tags."
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "test", "staging", "prod"], var.environment)
    error_message = "environment must be one of: dev, test, staging, prod."
  }
}

variable "tags" {
  description = "Extra tags merged into the default tags on every resource."
  type        = map(string)
  default     = {}
}

# --- Networking -------------------------------------------------------------

variable "address_space" {
  description = "Address space of the virtual network."
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "vm_subnet_prefix" {
  description = "Address prefix of the VM subnet."
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "aks_subnet_prefix" {
  description = "Address prefix of the AKS node subnet."
  type        = list(string)
  default     = ["10.0.2.0/24"]
}

variable "appgw_subnet_prefix" {
  description = "Address prefix of the dedicated Application Gateway subnet (only used when enable_agic = true)."
  type        = list(string)
  default     = ["10.0.3.0/24"]
}

variable "allowed_ssh_cidrs" {
  description = "CIDR blocks allowed to reach the VM over SSH, e.g. [\"203.0.113.10/32\"]. Required; wildcards are rejected."
  type        = list(string)

  validation {
    condition     = length(var.allowed_ssh_cidrs) > 0 && alltrue([for c in var.allowed_ssh_cidrs : can(cidrhost(c, 0)) && c != "0.0.0.0/0"])
    error_message = "allowed_ssh_cidrs must be a non-empty list of valid CIDRs and must not contain 0.0.0.0/0."
  }
}

variable "aks_allowed_inbound_ports" {
  description = "TCP ports opened to the internet on the AKS subnet NSG. Add extra ports (e.g. 3000 for Grafana) only when needed."
  type        = list(number)
  default     = [80, 443]
}

# --- Virtual machine --------------------------------------------------------

variable "admin_username" {
  description = "Administrator username of the VM (SSH key authentication only)."
  type        = string
  default     = "azureuser"

  validation {
    condition     = !contains(["root", "admin", "administrator"], lower(var.admin_username))
    error_message = "admin_username must not be a reserved name such as root or admin."
  }
}

variable "ssh_public_key_path" {
  description = "Path to the SSH public key installed on the VM."
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "vm_size" {
  description = "Size of the virtual machine."
  type        = string
  default     = "Standard_B2s"
}

# --- AKS --------------------------------------------------------------------

variable "node_vm_size" {
  description = "VM size of the AKS default node pool."
  type        = string
  default     = "Standard_D2s_v3"
}

variable "node_count" {
  description = "Number of nodes in the AKS default node pool."
  type        = number
  default     = 2

  validation {
    condition     = var.node_count >= 1 && var.node_count <= 10
    error_message = "node_count must be between 1 and 10."
  }
}

variable "enable_agic" {
  description = "Enable the Application Gateway Ingress Controller add-on (creates an Application Gateway, which is billed hourly)."
  type        = bool
  default     = true
}
