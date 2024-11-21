# VMs
resource "azurerm_linux_virtual_machine" "vm" {
  count               = var.nodecount
  name                = "${var.prefix}-vm${count.index + 1}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  size                = "Standard_A2_v2"
  disable_password_authentication = false

  network_interface_ids = [azurerm_network_interface.nic[count.index].id]

  admin_username = var.username
  admin_password = var.password
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = "${var.prefix}-osdisk-${count.index + 1}"
  }
  source_image_reference {
    offer     = "0001-com-ubuntu-server-jammy"
    publisher = "Canonical"
    sku       = "22_04-lts"
    version   = "latest"
  }

}






