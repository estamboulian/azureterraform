provider "vault" {
  address = "http://127.0.0.1:8200"
  a   = "hvs.gW75CPVIU3wZ8iyisraHNSKr"
}

data "vault_generic_secret" "admin" {
  path = "secret/admin"
}



resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}



module "network" {
  source              = "./modules/network"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  subnets = [
    { name = "subnet1", prefix = "10.0.1.0/24" },
    { name = "subnet2", prefix = "10.0.2.0/24" }
  ]
}

resource "azurerm_public_ip" "public_ip" {
  count               = var.vm_count
  name                = "public-ip-${count.index}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}


resource "azurerm_network_interface" "nic" {
  count               = var.vm_count
  name                = "nic-${count.index}"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = module.network.subnet_ids[count.index]
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip[count.index].id
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  count                = var.vm_count
  name                 = "vm-${count.index}"
  location             = var.location
  resource_group_name  = var.resource_group_name
  size                 = var.vm_size
  admin_username       = data.vault_generic_secret.admin.data["username"]

  admin_ssh_key {
    username   = data.vault_generic_secret.admin.data["username"]
    public_key = file(var.admin_ssh_key)
  }

  network_interface_ids = [azurerm_network_interface.nic[count.index].id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
}
