output "server_public_ip" {
  description = "IP publique du control-plane"
  value       = hcloud_server.server.ipv4_address
}

output "server_private_ip" {
  description = "IP privée du control-plane"
  value       = "10.0.1.10"
}

output "agents_public_ips" {
  description = "IPs publiques des workers"
  value       = hcloud_server.agents[*].ipv4_address
}

output "agents_private_ips" {
  description = "IPs privées des workers"
  value       = [for i in range(2) : "10.0.1.${20 + i}"]
}

output "ssh_connection_server" {
  description = "Commande SSH vers le server"
  value       = "ssh root@${hcloud_server.server.ipv4_address}"
}
