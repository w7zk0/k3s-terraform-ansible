locals {
  # Adresses IP statiques → adapte selon ton réseau local
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

  # Clone depuis un template cloud-init existant (recommandé)
  clone {
    vm_id = var.template_id
    full  = true
  }

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
      keys     = [trimspace(var.ssh_public_key)]
    }
  }

  operating_system {
    type = "l26"
  }

  serial_device {}

  startup {
    order      = 1
    up_delay   = 30
    down_delay = 30
  }
}

# ====================== Workers ======================
resource "proxmox_virtual_environment_vm" "agents" {
  count = 2

  name        = "${var.cluster_name}-agent-${count.index + 1}"
  node_name   = var.proxmox_node
  description = "k3s worker node"
  tags        = ["k3s", "agent"]

  clone {
    vm_id = var.template_id
    full  = true
  }

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
      keys     = [trimspace(var.ssh_public_key)]
    }
  }

  operating_system {
    type = "l26"
  }

  serial_device {}
}
