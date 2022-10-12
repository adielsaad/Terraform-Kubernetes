resource "azurerm_linux_virtual_machine" "vms" {
  name                = "myVm${count.index}"
  count               = var.vms_quantity
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = var.vm_size
  admin_username      = "${var.user_name}${count.index}"
  network_interface_ids = [
    element(azurerm_network_interface.nic.*.id, count.index)
  ]

  admin_ssh_key {
    username   = "${var.user_name}${count.index}"
    public_key = file(var.key_path)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }
}