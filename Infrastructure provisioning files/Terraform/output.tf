output "ssh_commands_master" {
  description = " SSH Command for the Master Node "
  value       = "ssh ${var.username}@${local.master_ip} "

}
output "ssh_commands_workers" {
  description = " SSH Commands for Worker Nodes "
  value       = [for ip in local.worker_ips : "ssh ${var.username}@${ip} "]
}

output "ansible_machine" {
  description = "vm for configuration"
      value       = "ssh ${var.username}@${azurerm_linux_virtual_machine.ansible.public_ip_address}} "

  
}