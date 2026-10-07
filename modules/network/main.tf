resource "azurerm_virtual_network" "vnet" {
  name                = "${var.name}-vnet"
  address_space       = var.address_space
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

# --- Subnets ----------------------------------------------------------------

resource "azurerm_subnet" "vm" {
  name                 = "${var.name}-vm-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.vm_subnet_prefix
}

resource "azurerm_subnet" "aks" {
  name                 = "${var.name}-aks-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.aks_subnet_prefix
}

# Application Gateway requires its own subnet, and must NOT share the AKS node
# subnet. It also has mandatory NSG rules (GatewayManager 65200-65535), so no NSG
# is attached here.
resource "azurerm_subnet" "appgw" {
  count = var.enable_appgw_subnet ? 1 : 0

  name                 = "${var.name}-appgw-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.appgw_subnet_prefix
}

# --- VM networking ----------------------------------------------------------

resource "azurerm_public_ip" "vm" {
  name                = "${var.name}-vm-pip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard" # Basic SKU is being retired
  tags                = var.tags
}

resource "azurerm_network_interface" "nic" {
  name                = "${var.name}-vm-nic"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.vm.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm.id
  }
}

resource "azurerm_network_security_group" "vm" {
  name                = "${var.name}-vm-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  security_rule {
    name                       = "AllowSSH"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefixes    = var.allowed_ssh_cidrs
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowHTTP"
    priority                   = 1010
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowHTTPS"
    priority                   = 1020
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Outbound traffic is allowed by the default NSG rules.
}

# The NSG only takes effect once it is attached.
resource "azurerm_network_interface_security_group_association" "vm" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.vm.id
}

# --- AKS networking ---------------------------------------------------------

resource "azurerm_network_security_group" "aks" {
  name                = "${var.name}-aks-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  dynamic "security_rule" {
    for_each = { for idx, port in var.aks_allowed_inbound_ports : tostring(port) => idx }

    content {
      name                       = "Allow-TCP-${security_rule.key}"
      priority                   = 1000 + security_rule.value * 10
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = security_rule.key
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "aks" {
  subnet_id                 = azurerm_subnet.aks.id
  network_security_group_id = azurerm_network_security_group.aks.id
}
