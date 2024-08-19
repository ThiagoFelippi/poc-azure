resource "azurerm_public_ip" "inspired" {
  name                = "PublicIPForLB"
  location            = var.location
  resource_group_name = var.resource_group
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Load Balancer
resource "azurerm_lb" "load_balancer" {
  name                = "inspired-lb"
  location            = var.location
  resource_group_name = var.resource_group
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = var.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.inspired.id
  }
}

resource "azurerm_lb_backend_address_pool" "load_balancer_pool" {
  loadbalancer_id = azurerm_lb.load_balancer.id
  name            = "backend-pool"
}

# Load Balancer Probe
resource "azurerm_lb_probe" "load_balancer_http_probe" {
  loadbalancer_id     = azurerm_lb.load_balancer.id
  name                = "http-probe"
  port                = 80
  interval_in_seconds = 5
  number_of_probes    = 2
}

# Load Balancer Rule
resource "azurerm_lb_rule" "load_balancer_http_rule" {
  loadbalancer_id                = azurerm_lb.load_balancer.id
  name                           = "http-rule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.load_balancer_pool.id]
  probe_id                       = azurerm_lb_probe.load_balancer_http_probe.id
  frontend_ip_configuration_name = var.frontend_ip_configuration_name
  disable_outbound_snat          = true
}

resource "azurerm_lb_outbound_rule" "load_balancer_outbound_rule" {
  name                    = "test-outbound"
  loadbalancer_id         = azurerm_lb.load_balancer.id
  protocol                = "Tcp"
  backend_address_pool_id = azurerm_lb_backend_address_pool.load_balancer_pool.id

  frontend_ip_configuration {
    name = var.frontend_ip_configuration_name
  }
}
