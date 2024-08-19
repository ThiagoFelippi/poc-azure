resource "azurerm_network_security_group" "vmss-ingress" {
  name                = "virtual-machine-ingress"
  location            = var.location
  resource_group_name = var.resource_group

  security_rule {
    name                       = "allow-http-Inbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
