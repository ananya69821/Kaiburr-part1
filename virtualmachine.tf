resource "azurerm_virtual_network" "virtual_network" {
  name                = "${var.env}-vnet01"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  address_space       = [var.virtual_network_addrs.vnetaddr]
  #dns_servers         = ["10.1.0.4", "10.1.0.5"]
}

resource "azurerm_subnet" "subnet" {
  name                                           = "${azurerm_virtual_network.virtual_network.name}-sub01"
  resource_group_name                            = azurerm_resource_group.this.name
  virtual_network_name                           = azurerm_virtual_network.virtual_network.name
  address_prefixes                               = [var.subnet_names.addrs]
  enforce_private_link_endpoint_network_policies = true
  enforce_private_link_service_network_policies  = true
 }

 resource "azurerm_public_ip" "publicIp" {
  name                = "${var.env}-pubIP"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  allocation_method   = "Static"

  tags = local.common_tags
  depends_on = [
    azurerm_subnet.subnet
  ]
}

resource "azurerm_network_interface" "main" {
  name                = "${azurerm_subnet.subnet.name}-nic"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address = "10.1.1.10"
    public_ip_address_id = azurerm_public_ip.publicIp.id
  }
  depends_on = [
    azurerm_public_ip.publicIp
  ]
}


resource "azurerm_virtual_machine" "main" {
  name                  = "${var.env}-vm01"
  location              = azurerm_resource_group.this.location
  resource_group_name   = azurerm_resource_group.this.name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = "Standard_D2s_v3"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    # caching           = "ReadWrite"
     create_option     = "FromImage"
    # managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "cicddemo"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = local.common_tags
}