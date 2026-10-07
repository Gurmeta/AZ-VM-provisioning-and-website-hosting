locals {
  name = "${var.name_prefix}-${var.environment}"

  tags = merge(
    {
      environment = var.environment
      managed_by  = "terraform"
      project     = "az-vm-provisioning"
    },
    var.tags
  )
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = local.tags
}

module "network" {
  source = "./modules/network"

  name                      = local.name
  resource_group_name       = azurerm_resource_group.rg.name
  location                  = azurerm_resource_group.rg.location
  address_space             = var.address_space
  vm_subnet_prefix          = var.vm_subnet_prefix
  aks_subnet_prefix         = var.aks_subnet_prefix
  appgw_subnet_prefix       = var.appgw_subnet_prefix
  enable_appgw_subnet       = var.enable_agic
  allowed_ssh_cidrs         = var.allowed_ssh_cidrs
  aks_allowed_inbound_ports = var.aks_allowed_inbound_ports
  tags                      = local.tags
}

module "compute" {
  source = "./modules/compute"

  name                 = local.name
  resource_group_name  = azurerm_resource_group.rg.name
  location             = azurerm_resource_group.rg.location
  network_interface_id = module.network.network_interface_id
  admin_username       = var.admin_username
  ssh_public_key       = trimspace(file(pathexpand(var.ssh_public_key_path)))
  vm_size              = var.vm_size
  tags                 = local.tags
}

module "aks" {
  source = "./modules/aks"

  name                = local.name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  aks_subnet_id       = module.network.aks_subnet_id
  appgw_subnet_id     = module.network.appgw_subnet_id
  node_vm_size        = var.node_vm_size
  node_count          = var.node_count
  tags                = local.tags

  # The AKS subnet NSG must exist before nodes are placed in the subnet.
  depends_on = [module.network]
}
