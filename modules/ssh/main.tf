resource "azurerm_resource_group" "ssh" {
  name     = "ssh-key-rg"
  location = var.location
}

resource "azurerm_ssh_public_key" "vm_ssh_key" {
  name                = "vm-ssh-key"
  resource_group_name = azurerm_resource_group.ssh.name
  location            = var.location
  public_key          = file("~/.ssh/id_rsa.pub")
}

