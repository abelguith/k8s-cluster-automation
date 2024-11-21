# Create the inventory file for Ansible on local machine
resource "local_file" "ansible_inventory" {
  content  = <<EOF
[all:vars]
ansible_ssh_common_args='-o StrictHostKeyChecking=no'

[master]
master ansible_host=${local.master_ip} ansible_user=${var.username} ansible_password=${var.password} 

[workers]
%{for idx, ip in local.worker_ips~}
worker${idx + 1} ansible_host=${ip} ansible_user=${var.username} ansible_password=${var.password} 
%{endfor~}

EOF
  filename = "../ansible-k8s-setup/inventory/inventory.ini"
}

resource "local_file" "init-task" {
  content  = <<EOF
---
- name: Initialize Kubernetes cluster
  shell: kubeadm init --pod-network-cidr=10.244.0.0/16 

- name: Create .kube directory
  become: yes
  become_user: "{{ ansible_user }}"
  file:
    path: $HOME/.kube
    state: directory
    mode: 0755

- name: Copy admin.conf to User's kube config
  copy:
    src: /etc/kubernetes/admin.conf
    dest: "/home/{{ ansible_user }}/.kube/config"
    remote_src: yes
    owner: "{{ ansible_user }}"
EOF
  filename = "../ansible-k8s-setup/playbook/roles/master_init/tasks/playbook.yml"
}

# Copy Ansible setup files to Ansible VM and execute playbook
resource "null_resource" "ansible_setup" {
  triggers = {
    ansible_vm_id = azurerm_linux_virtual_machine.ansible.id
    inventory_content = local_file.ansible_inventory.content
  }

  provisioner "file" {
    source      = "../ansible-k8s-setup/"
    destination = "/home/${var.username}"
    connection {
      type     = "ssh"
      user     = var.username
      password = var.password
      host     = azurerm_linux_virtual_machine.ansible.public_ip_address
      timeout  = "4m"
      agent    = false
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y ansible",
      "sudo apt-get install sshpass",
      "cd /home/${var.username}/ansible-k8s-setup",
      "ls -l inventory/inventory.ini",  # Check if the file exists
      "cat inventory/inventory.ini",    # Display the content of the file
      "ansible-playbook -i inventory/inventory.ini playbook/playbook.yml"
    ]
    connection {
      type     = "ssh"
      user     = var.username
      password = var.password
      host     = azurerm_linux_virtual_machine.ansible.public_ip_address
      timeout  = "4m"
      agent    = false
    }
  }

  depends_on = [azurerm_linux_virtual_machine.ansible, local_file.ansible_inventory, local_file.init-task]
}