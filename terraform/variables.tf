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
  description = "Utilisateur SSH pour le provider"
  type        = string
  default     = "root"
}

variable "proxmox_node" {
  description = "Nom du nœud Proxmox"
  type        = string
  default     = "pve"
}

variable "template_id" {
  description = "VMID du template cloud-init Ubuntu (ex: 9000)"
  type        = number
}

variable "vm_storage" {
  description = "Storage Proxmox pour les disques"
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
  description = "Mémoire en Mo pour le control-plane"
  type        = number
  default     = 4096
}

variable "agent_cores" {
  type    = number
  default = 2
}

variable "agent_memory" {
  description = "Mémoire en Mo pour les workers"
  type        = number
  default     = 4096
}

variable "disk_size" {
  description = "Taille du disque en Go"
  type        = number
  default     = 30
}
