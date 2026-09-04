# Clé SSH
resource "hcloud_ssh_key" "default" {
  name       = var.ssh_key_name
  public_key = var.ssh_public_key
}

# Network privé (optionnel mais recommandé)
resource "hcloud_network" "k3s" {
  name     = "${var.cluster_name}-net"
  ip_range = "10.0.0.0/16"
}

resource "hcloud_network_subnet" "k3s" {
  network_id   = hcloud_network.k3s.id
  type         = "cloud"
  network_zone = "eu-central"
  ip_range     = "10.0.1.0/24"
}

# Control Plane (Server)
resource "hcloud_server" "server" {
  name        = "${var.cluster_name}-server"
  server_type = var.server_type
  image       = var.os_image
  location    = var.location
  ssh_keys    = [hcloud_ssh_key.default.id]

  labels = {
    role = "server"
  }

  public_net {
    ipv4_enabled = true
    ipv6_enabled = false
  }

  network {
    network_id = hcloud_network.k3s.id
    ip         = "10.0.1.10"
  }

  user_data = <<-EOF
    #cloud-config
    package_update: true
    package_upgrade: true
  EOF
}

# Workers (Agents)
resource "hcloud_server" "agents" {
  count       = 2
  name        = "${var.cluster_name}-agent-${count.index + 1}"
  server_type = var.server_type
  image       = var.os_image
  location    = var.location
  ssh_keys    = [hcloud_ssh_key.default.id]

  labels = {
    role = "agent"
  }

  public_net {
    ipv4_enabled = true
    ipv6_enabled = false
  }

  network {
    network_id = hcloud_network.k3s.id
    ip         = "10.0.1.${20 + count.index}"
  }

  user_data = <<-EOF
    #cloud-config
    package_update: true
    package_upgrade: true
  EOF
}

# Firewall basique
resource "hcloud_firewall" "k3s" {
  name = "${var.cluster_name}-fw"

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "22"
    source_ips = ["0.0.0.0/0"]
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "6443"
    source_ips = ["0.0.0.0/0"]
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "10250"
    source_ips = ["0.0.0.0/0"]
  }

  rule {
    direction = "in"
    protocol  = "udp"
    port      = "8472"
    source_ips = ["0.0.0.0/0"]
  }
}

resource "hcloud_firewall_attachment" "k3s" {
  firewall_id = hcloud_firewall.k3s.id
  server_ids = concat(
    [hcloud_server.server.id],
    hcloud_server.agents[*].id
  )
}
