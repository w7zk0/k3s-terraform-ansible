locals {
  # Adresses IP statiques (adapte selon ton réseau)
  server_ip = "192.168.1.110"
  agent_ips = ["192.168.1.111", "192.168.1.112"]
  gateway   = "192.168.1.1"
  cidr      = 24
}

# ====================== Control Plane ======================
resource "proxmox_virtual_environment_vm" "server" {
  name        = "${var.cluster_name}-server"
  node_name   = var.proxmox_node
  description = "k3s control-plane"
  tags        = ["k3s", "server"]

  agent {
    enabled = true
  }

  cpu {
    cores = var.server_cores
    type  = "host"
  }

  memory {
    dedicated = var.server_memory
  }

  disk {
    datastore_id = var.vm_storage
    file_id      = proxmox_virtual_environment_file.cloud_image.id
    interface    = "scsi0"
    size         = var.disk_size
    discard      = "on"
  }

  network_device {
    bridge = var.bridge
  }

  initialization {
    ip_config {
      ipv4 {
        address = "${local.server_ip}/${local.cidr}"
        gateway = local.gateway
      }
    }

    user_account {
      username = "ubuntu"
      keys     = [var.ssh_public_key]
    }

    # Ou utilise un snippet cloud-init plus avancé si besoin
  }

  operating_system {
    type = "l26"
  }

  serial_device {}
}

# ====================== Workers ======================
resource "proxmox_virtual_environment_vm" "agents" {
  count = 2

  name        = "${var.cluster_name}-agent-${count.index + 1}"
  node_name   = var.proxmox_node
  description = "k3s worker"
  tags        = ["k3s", "agent"]

  agent {
    enabled = true
  }

  cpu {
    cores = var.agent_cores
    type  = "host"
  }

  memory {
    dedicated = var.agent_memory
  }

  disk {
    datastore_id = var.vm_storage
    file_id      = proxmox_virtual_environment_file.cloud_image.id
    interface    = "scsi0"
    size         = var.disk_size
    discard      = "on"
  }

  network_device {
    bridge = var.bridge
  }

  initialization {
    ip_config {
      ipv4 {
        address = "${local.agent_ips[count.index]}/${local.cidr}"
        gateway = local.gateway
      }
    }

    user_account {
      username = "ubuntu"
      keys     = [var.ssh_public_key]
    }
  }

  operating_system {
    type = "l26"
  }

  serial_device {}
}

# Image cloud (uploadée une seule fois)
# Tu dois d'abord télécharger l'image Ubuntu cloud sur ton Proxmox
# ou utiliser un template existant.
resource "proxmox_virtual_environment_file" "cloud_image" {
  content_type = "iso"          # ou "import" selon ta version
  datastore_id = "local"        # adapte
  node_name    = var.proxmox_node

  source_file {
    path = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
    # Ou chemin local si tu préfères uploader manuellement
  }
}
