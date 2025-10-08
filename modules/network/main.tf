resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-tp"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "subnets" {
  for_each = { for s in var.subnets : s.name => s }

  name                 = each.value.name
  address_prefixes     = [each.value.prefix]
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
}

output "subnet_ids" {
  value = [for s in azurerm_subnet.subnets : s.id]
}
