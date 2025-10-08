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
  default = "Standard_B2s"
}




variable "admin_ssh_key" {
  default = "~/.ssh/id_rsa.pub"
}
