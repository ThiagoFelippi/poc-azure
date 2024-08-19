locals {
  first_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDa5jXytrzfCnDzr3Su2WEcr8a6gRS+10odr+W7xEUAExamPwIFIfMH9rZyrU10xClo2FHtT0JVDvG5P+FgFSrEI/B9Fgob/eJZGDTsF5v+urbZon/X8Li0QoCBRB75ug11t5HxQ5bWiHnWZ6oIi4XHn93lTX0brThcW5pIap8LvkYEJJf0ueCn8xOQFdVC8Ri2rXc1B6g4LLOC9FRmXgo0wYvP5/6Vj4GzSY9S+jXvpEPyEwzoUswxMOxyU00k9h9eCE26ERqjYAVHbY4mYirDXfhrRep5lXU5F0z3+VIqUM4ZfEtnIdDlVJeo4Knrii/uPr0O0Hj1tD82hbq+H+iqAgDFXwmQgHkz26D8SIAEASQqN5NMBxwxidOQKU72LQy66zHy8gvTq515jnKfi1kTo0CqykLbDLfXMh+N7XxdpKFclntF4LDIasSzNrDfvE9+OW7eLjuzO/DPlJUB29TfvATgduNQWvGfmm5b2lnCvQ9ZlXI327fVzVrxpyvk/WM= thiagocrespofelippi@Thiagos-MacBook-Pro.local"
}

resource "azurerm_linux_virtual_machine_scale_set" "inspired" {
  name                = "inspired-vmss"
  resource_group_name = var.resource_group
  location            = var.location
  sku                 = "Standard_F2"
  instances           = 1
  admin_username      = "adminuser"
  zone_balance        = true
  zones               = ["1", "2", "3"]
  upgrade_mode        = "Automatic"
  health_probe_id     = var.probe_id

  automatic_os_upgrade_policy {
    enable_automatic_os_upgrade = true
    disable_automatic_rollback  = true
  }

  admin_ssh_key {
    username   = "adminuser"
    public_key = local.first_public_key
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "inspired-nic"
    primary = true

    ip_configuration {
      name      = "internal"
      primary   = true
      subnet_id = var.subnet_id

      load_balancer_backend_address_pool_ids = [
        var.lb_pool_id
      ]
    }
  }
}

# resource "azurerm_monitor_autoscale_setting" "inspired" {
#   name                = "myAutoscaleSetting"
#   resource_group_name = var.resource_group
#   location            = var.location
#   target_resource_id  = azurerm_linux_virtual_machine_scale_set.inspired.id

#   profile {
#     name = "defaultProfile"

#     capacity {
#       default = 1
#       minimum = 1
#       maximum = 3
#     }

#     rule {
#       metric_trigger {
#         metric_name        = "Percentage CPU"
#         metric_resource_id = azurerm_linux_virtual_machine_scale_set.inspired.id
#         time_grain         = "PT1M"
#         statistic          = "Average"
#         time_window        = "PT5M"
#         time_aggregation   = "Average"
#         operator           = "GreaterThan"
#         threshold          = 75
#         metric_namespace   = "microsoft.compute/virtualmachinescalesets"

#         dimensions {
#           name     = "AppName"
#           operator = "Equals"
#           values   = ["App1"]
#         }
#       }

#       scale_action {
#         direction = "Increase"
#         type      = "ChangeCount"
#         value     = "1"
#         cooldown  = "PT1M"
#       }
#     }

#     rule {
#       metric_trigger {
#         metric_name        = "Percentage CPU"
#         metric_resource_id = azurerm_linux_virtual_machine_scale_set.inspired.id
#         time_grain         = "PT1M"
#         statistic          = "Average"
#         time_window        = "PT5M"
#         time_aggregation   = "Average"
#         operator           = "LessThan"
#         threshold          = 25
#       }

#       scale_action {
#         direction = "Decrease"
#         type      = "ChangeCount"
#         value     = "1"
#         cooldown  = "PT1M"
#       }
#     }
#   }
# }
