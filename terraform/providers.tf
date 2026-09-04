terraform {
  required_version = ">= 1.5.0"

  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.66"
    }
  }
}

provider "proxmox" {
  endpoint = var.proxmox_endpoint
  username = var.proxmox_username
  password = var.proxmox_password
  # Ou utilise un token (recommandé) :
  # api_token = var.proxmox_api_token

  insecure = var.proxmox_insecure # true si certificat auto-signé

  ssh {
    agent    = true
    username = var.proxmox_ssh_username
  }
}
