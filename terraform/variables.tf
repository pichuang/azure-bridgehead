variable "lab-rg" {
  description = "Resource Group for this lab"
  type        = string
  default     = "rg-bridgehead-jpe-999"
}

variable "lab-location" {
  description = "Location for this lab"
  type        = string
  default     = "japaneast"
}

variable "tags" {
  description = "Set of tags for resources"
  type        = map(any)
  default = {
    ApplicationName = "Bridgehead 999"
  }
}

variable "vm_hub_port" {
  description = "Port for the VM Hub"
  type        = number
  default     = 5566
}

variable "admin_username" {
  description = "Username for the admin account"
  type        = string
  default     = "repairman"
}

variable "admin_password" {
  description = "Password for the admin account"
  type        = string
  default     = "Lyc0r!sRec0il"
  sensitive   = true
}
