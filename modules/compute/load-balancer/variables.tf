variable "resource_group" {
  type        = string
  description = "resource_group"
}

variable "location" {
  type        = string
  description = "location"
}

variable "frontend_ip_configuration_name" {
  type        = string
  description = "frontend_ip_configuration_name"
  default     = "PublicIPAddress"
}
