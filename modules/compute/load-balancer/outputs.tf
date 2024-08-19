output "lb_pool_id" {
  value = azurerm_lb_backend_address_pool.load_balancer_pool.id
}

output "probe_id" {
  value = azurerm_lb_probe.load_balancer_http_probe.id
}

output "public_ip" {
  value = azurerm_public_ip.inspired.ip_address
}
