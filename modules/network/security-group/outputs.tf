output "security_group_id" {
  description = "security_group_id"
  value       = azurerm_network_security_group.vmss-ingress.id
}
