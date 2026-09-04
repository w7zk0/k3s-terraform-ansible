# Architecture du cluster (Proxmox)

## Vue d'ensemble

Ce projet déploie un cluster **k3s** minimal sur **Proxmox** composé de :

- **1 Control Plane** (rôle `server`)
- **2 Workers** (rôle `agent`)

### Composants inclus par défaut dans k3s

| Composant       | Description                          | Activé |
|-----------------|--------------------------------------|--------|
| etcd (embedded) | Stockage des données du cluster      | Oui    |
| Flannel         | CNI (réseau pods)                    | Oui    |
| CoreDNS         | DNS interne                          | Oui    |
| Traefik         | Ingress Controller                   | Oui    |
| ServiceLB       | LoadBalancer (Klipper)               | Oui    |
| local-path      | StorageClass                         | Oui    |
| metrics-server  | Metrics API                          | Oui    |

## Flux de déploiement

1. **Terraform** clone un template cloud-init Ubuntu sur Proxmox et configure les VMs (IP statique, clé SSH, ressources).
2. **Ansible** :
   - Applique le rôle `common` (packages, swap off, sysctl, fail2ban...)
   - Installe k3s sur le node `server`
   - Récupère le token
   - Joint les agents au cluster

## Réseau (exemple)

- Server : `192.168.1.110`
- Agents : `192.168.1.111` et `192.168.1.112`
- Bridge Proxmox : `vmbr0`

Tu peux modifier ces valeurs dans `terraform/main.tf` (bloc `locals`).

## Points importants Proxmox

- Un template cloud-init avec `qemu-guest-agent` est **obligatoire**
- Le provider utilisé est `bpg/proxmox` (moderne et bien maintenu)
- Les VMs sont clonées en full clone

## Évolutivité

- Augmenter le nombre d'agents facilement
- Ajouter un second control-plane pour du HA
- Brancher Longhorn / Rook pour le stockage
- Ajouter MetalLB si besoin d'IPs LoadBalancer
