terraform {
  required_version = ">= 1.5.0"

  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.45"
    }
  }
}

# Exemple avec Hetzner Cloud (très populaire pour les labs)
# Tu peux remplacer par aws, digitalocean, azurerm, proxmox, etc.

provider "hcloud" {
  token = var.hcloud_token
}
