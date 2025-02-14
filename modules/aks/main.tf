resource "azurerm_kubernetes_cluster" "aks" {
  name                = "GBS-java-dev-aks-cluster"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "exampleaks"

  identity {
    type = "SystemAssigned"
  }

  network_profile {
   network_plugin = "azure"
   network_policy = "calico"
   service_cidr = "10.1.0.0/16"  # Change to avoid conflicts with the VNet address space
   dns_service_ip = "10.1.0.10"  # Should be within the new service CIDR range
  }
  # network_profile {
  #   network_plugin      = "azure"
  #   # network_plugin_mode = "overlay"
  #   # service_cidr        = "10.1.0.0/16"
  #   # dns_service_ip      = "10.1.0.10"
  #   # pod_cidr            = "10.244.0.0/16"
  #   # outbound_type       = "loadBalancer"

  #   # Attach the public IP for outbound traffic
  #   load_balancer_profile {
  #     managed_outbound_ip_count = 0
  #     outbound_ip_address_ids = [var.aks_public_ip_id]
  #   }
  #}
 
  ingress_application_gateway {
    subnet_id = var.aks_subnet_id
  }
  default_node_pool {
    name           = "default"
    node_count     = 2
    vm_size        = var.node_vm_size
    vnet_subnet_id = var.aks_subnet_id
  }

  tags = {
    environment = "dev"
  }
}
