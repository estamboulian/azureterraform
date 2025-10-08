variable "resource_group_name" {
  default = "rg-vm-network"
}

variable "location" {
  default = "eastus"
}

variable "vm_count" {
  default = 2
}

variable "vm_size" {
  default = "Standard_B1s"
}

variable "admin_username" {
  default = "azureuser"
}

variable "admin_password" {
  default = "Azerty123!"
}


variable "admin_ssh_key" {
  default = "~/.ssh/id_rsa.pub"
}
