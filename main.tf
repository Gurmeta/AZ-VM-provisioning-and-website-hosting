resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

module "network" {
  source              = "./modules/network"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  address_space       = var.address_space
  subnet_prefix       = var.subnet_prefix
  subnet_id = var.subnet_id
}


module "compute" {
  source              = "./modules/compute"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  network_interface_id = module.network.network_interface_id
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  vm_size             = var.vm_size
}

module "aks" {
  source              = "./modules/aks"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  subnet_id           = module.network.subnet_id  # Pass subnet_id from the network module
  node_vm_size        = var.node_vm_size
  aks_subnet_id       = module.network.aks_subnet_id
  aks_nsg_id          = module.network.aks_nsg_id
  aks_public_ip_id    = module.network.aks_public_ip_id
}
module "ssh" {
  source = "./modules/ssh"
}

