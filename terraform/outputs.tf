output "server_ip" {
  description = "IP du control-plane"
  value       = local.server_ip
}

output "agents_ips" {
  description = "IPs des workers"
  value       = local.agent_ips
}

output "ssh_server" {
  description = "Commande SSH vers le server"
  value       = "ssh ubuntu@${local.server_ip}"
}

output "ansible_inventory_hint" {
  description = "Exemple pour inventory/hosts.yml"
  value       = <<-EOT
    server:
      hosts:
        k3s-server:
          ansible_host: ${local.server_ip}
          ansible_user: ubuntu

    agents:
      hosts:
        k3s-agent-1:
          ansible_host: ${local.agent_ips[0]}
          ansible_user: ubuntu
        k3s-agent-2:
          ansible_host: ${local.agent_ips[1]}
          ansible_user: ubuntu
  EOT
}
