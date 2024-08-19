output "subnet_ids" {
  description = "Subnet IDs output"
  value       = azurerm_virtual_network.inspired.subnet
}

# {
#   address_prefix = "10.0.1.0/24"
#   id             = "/subscriptions/cf5d7968-c982-473a-97ff-b9669bf42d35/resourceGroups/inspired/providers/Microsoft.Network/virtualNetworks/poc-inspired/subnets/subnet1"
#   name           = "subnet1"
#   security_group = ""
# }
