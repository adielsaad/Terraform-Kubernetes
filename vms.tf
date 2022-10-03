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

  connection {
    type        = "ssh"
    user        = "${var.user_name}${count.index}"
    private_key = file(var.private_key)
    host        = element(azurerm_public_ip.IP.*.ip_address, count.index)
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",
      "sudo apt -y install curl apt-transport-https",
      "curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -",
      "echo 'deb https://apt.kubernetes.io/ kubernetes-xenial main' | sudo tee /etc/apt/sources.list.d/kubernetes.list",
      "sudo apt update",
      "sudo apt install -y docker.io kubectl kubeadm kubelet",
      "sudo apt-mark hold kubelet kubeadm kubectl",
      "sudo systemctl enable kubelet",
      "sudo kubeadm init --pod-network-cidr=10.244.0.0/16",
      "mkdir -p $HOME/.kube",
      "sudo cp -f /etc/kubernetes/admin.conf $HOME/.kube/config",
      "sudo chown $(id -u):$(id -g) $HOME/.kube/config",
      "kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml",
      "kubectl get nodes"
    ]
  }
}