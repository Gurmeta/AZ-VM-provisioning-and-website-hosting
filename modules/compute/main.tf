resource "azurerm_linux_virtual_machine" "vm" {
  name                  = "GBS-devgroup-VM"
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [var.network_interface_id]
  size                  = var.vm_size

  admin_username = var.admin_username
  disable_password_authentication = true 

  custom_data = filebase64("${path.module}/provision.sh")  # Use a bash script for provisioning

  admin_ssh_key {
    username   = var.admin_username
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    name                 = "Prod-group-VM-OS-Disk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }

  tags = {
    environment = "Production"
  }
}

output "vm_id" {
  description = "The ID of the Virtual Machine"
  value       = azurerm_linux_virtual_machine.vm.id
}
