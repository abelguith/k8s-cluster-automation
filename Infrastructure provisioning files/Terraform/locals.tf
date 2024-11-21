locals {
  master_ip  = azurerm_linux_virtual_machine.vm[0].public_ip_address
  worker_ips = [for i in range(1, length(azurerm_linux_virtual_machine.vm)) : azurerm_linux_virtual_machine.vm[i].public_ip_address]
}
