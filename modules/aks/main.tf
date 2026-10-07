resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.name}-aks"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "${var.name}-aks"

  role_based_access_control_enabled = true

  identity {
    type = "SystemAssigned"
  }

  default_node_pool {
    name           = "default"
    node_count     = var.node_count
    vm_size        = var.node_vm_size
    vnet_subnet_id = var.aks_subnet_id
  }

  network_profile {
    network_plugin = "azure"
    network_policy = "calico"
    service_cidr   = var.service_cidr
    dns_service_ip = var.dns_service_ip
  }

  # Application Gateway Ingress Controller, placed in its own dedicated subnet.
  dynamic "ingress_application_gateway" {
    for_each = var.appgw_subnet_id == null ? [] : [var.appgw_subnet_id]

    content {
      gateway_name = "${var.name}-agw"
      subnet_id    = ingress_application_gateway.value
    }
  }

  tags = var.tags
}
