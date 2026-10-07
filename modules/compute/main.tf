resource "azurerm_linux_virtual_machine" "vm" {
  name                  = "${var.name}-vm"
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [var.network_interface_id]
  size                  = var.vm_size

  admin_username                  = var.admin_username
  disable_password_authentication = true

  # cloud-init runs this script as root on first boot.
  custom_data = filebase64("${path.module}/provision.sh")

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }

  os_disk {
    name                 = "${var.name}-vm-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }

  tags = var.tags
}
