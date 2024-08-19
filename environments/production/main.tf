module "create-load-balancer" {
  source         = "../../modules/compute/load-balancer"
  resource_group = azurerm_resource_group.inspired.name
  location       = azurerm_resource_group.inspired.location
}

module "create-security-group" {
  source         = "../../modules/network/security-group"
  resource_group = azurerm_resource_group.inspired.name
  location       = azurerm_resource_group.inspired.location
  public_ip      = module.create-load-balancer.public_ip
}

module "create-vnet" {
  source         = "../../modules/network/vnet"
  resource_group = azurerm_resource_group.inspired.name
  location       = azurerm_resource_group.inspired.location
  nsg_id         = module.create-security-group.security_group_id
}

module "create-vmss" {
  source         = "../../modules/compute/create-vmss"
  resource_group = azurerm_resource_group.inspired.name
  location       = azurerm_resource_group.inspired.location
  subnet_id      = tolist(module.create-vnet.subnet_ids)[0].id
  lb_pool_id     = module.create-load-balancer.lb_pool_id
  probe_id       = module.create-load-balancer.probe_id
}

module "webserver" {
  source       = "../../modules/applications/webserver"
  scale_set_id = module.create-vmss.scale_set_id
}
