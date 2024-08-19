resource "azurerm_virtual_network" "inspired" {
  name                = "poc-inspired"
  resource_group_name = var.resource_group
  location            = var.location
  address_space       = ["10.0.0.0/16"]

  subnet {
    name           = "subnet1"
    address_prefix = "10.0.1.0/24"
  }
}

resource "azurerm_subnet_network_security_group_association" "subnet1_nsg" {
  subnet_id                 = tolist(azurerm_virtual_network.inspired.subnet)[0].id
  network_security_group_id = var.nsg_id
}
