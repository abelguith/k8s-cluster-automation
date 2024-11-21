resource "azurerm_public_ip" "ansible" {
  name                = "${var.prefix}-public-ip-vm-ansible"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
}
# Network interfaces
resource "azurerm_network_interface" "ansible" {
  name                = "${var.prefix}-interface-vm-ansible"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "${var.prefix}-interface-vm-ansible-config"
    subnet_id                     = azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.ansible.id
  }
}

resource "azurerm_linux_virtual_machine" "ansible" {
  name                            = "${var.prefix}-ansible-vm"
  location                        = azurerm_resource_group.main.location
  resource_group_name             = azurerm_resource_group.main.name
  size                            = "Standard_D1_v2"
  disable_password_authentication = false
  timeouts {
    create = "10m"
    delete = "30m"
  }

  network_interface_ids = [azurerm_network_interface.ansible.id]

  admin_username = var.username
  admin_password = var.password

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = "${var.prefix}-osdisk-ansible"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }


  connection {
    type        = "ssh"
    user        = var.username
    password    = Ahmed1234
    host        = self.public_ip_address
    timeout     = "4m"
    agent       = false

  }
  
}
resource "azurerm_network_security_group" "ansible" {
  name                = "${var.prefix}-nsg-ansible"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "ansible" {
  network_interface_id      = azurerm_network_interface.ansible.id
  network_security_group_id = azurerm_network_security_group.ansible.id
}