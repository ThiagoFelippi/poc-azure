resource "azurerm_virtual_machine_scale_set_extension" "inspired" {
  name                         = "inspired"
  virtual_machine_scale_set_id = var.scale_set_id
  publisher                    = "Microsoft.Azure.Extensions"
  type                         = "CustomScript"
  type_handler_version         = "2.0"
  settings = jsonencode({
    "commandToExecute" = "sudo apt-get update && sudo apt-get install -y docker.io && sudo systemctl start docker && sudo systemctl enable docker && docker run -d -p 80:80 --name nginx nginx"
  })
}

