variable "hcloud_token" {
  description = "Hetzner Cloud API Token"
  type        = string
  sensitive   = true
}

variable "ssh_public_key" {
  description = "Contenu de ta clé publique SSH"
  type        = string
}

variable "ssh_key_name" {
  description = "Nom de la clé SSH dans Hetzner"
  type        = string
  default     = "k3s-key"
}

variable "location" {
  description = "Datacenter Hetzner (ex: nbg1, fsn1, hel1)"
  type        = string
  default     = "nbg1"
}

variable "server_type" {
  description = "Type de serveur (cx22 = 2vCPU/4GB recommandé)"
  type        = string
  default     = "cx22"
}

variable "os_image" {
  description = "Image OS"
  type        = string
  default     = "ubuntu-24.04"
}

variable "cluster_name" {
  description = "Préfixe des ressources"
  type        = string
  default     = "k3s"
}
