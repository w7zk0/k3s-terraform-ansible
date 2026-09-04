variable "proxmox_endpoint" {
  description = "URL de l'API Proxmox (ex: https://proxmox.example.com:8006/)"
  type        = string
}

variable "proxmox_username" {
  description = "Utilisateur Proxmox (ex: root@pam ou terraform@pve)"
  type        = string
  default     = "root@pam"
}

variable "proxmox_password" {
  description = "Mot de passe Proxmox"
  type        = string
  sensitive   = true
}

variable "proxmox_insecure" {
  description = "Accepter les certificats auto-signés"
  type        = bool
  default     = true
}

variable "proxmox_ssh_username" {
  description = "Utilisateur SSH pour le provider (généralement root)"
  type        = string
  default     = "root"
}

variable "proxmox_node" {
  description = "Nom du nœud Proxmox sur lequel créer les VMs"
  type        = string
  default     = "pve"
}

variable "template_name" {
  description = "Nom du template cloud-init Ubuntu (doit exister sur le nœud)"
  type        = string
  default     = "ubuntu-24.04-cloud"
}

variable "vm_storage" {
  description = "Storage Proxmox pour les disques (ex: local-lvm)"
  type        = string
  default     = "local-lvm"
}

variable "bridge" {
  description = "Bridge réseau Proxmox"
  type        = string
  default     = "vmbr0"
}

variable "ssh_public_key" {
  description = "Clé publique SSH à injecter dans les VMs"
  type        = string
}

variable "cluster_name" {
  description = "Préfixe des VMs"
  type        = string
  default     = "k3s"
}

variable "server_cores" {
  type    = number
  default = 2
}

variable "server_memory" {
  description = "Mémoire en Mo"
  type        = number
  default     = 4096
}

variable "agent_cores" {
  type    = number
  default = 2
}

variable "agent_memory" {
  description = "Mémoire en Mo"
  type        = number
  default     = 4096
}

variable "disk_size" {
  description = "Taille du disque en Go"
  type        = number
  default     = 30
}
