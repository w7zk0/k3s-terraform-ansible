# Architecture du cluster

## Vue d'ensemble

Ce projet déploie un cluster **k3s** minimal composé de :

- **1 Control Plane** (rôle `server`)
- **2 Workers** (rôle `agent`)

### Composants inclus par défaut dans k3s

| Composant       | Description                          | Activé |
|-----------------|--------------------------------------|--------|
| etcd (embedded) | Stockage des données du cluster      | Oui    |
| Flannel         | CNI (réseau pods)                    | Oui    |
| CoreDNS         | DNS interne                          | Oui    |
| Traefik         | Ingress Controller                   | Oui*   |
| ServiceLB       | LoadBalancer (Klipper)               | Oui    |
| local-path      | StorageClass                         | Oui    |
| metrics-server  | Metrics API                          | Oui    |

\* Traefik peut être désactivé via `--disable=traefik` dans les arguments serveur.

## Flux de déploiement

1. **Terraform** crée les VMs, le réseau privé, le firewall et injecte la clé SSH.
2. **Ansible** :
   - Applique le rôle `common` (OS hardening léger, packages, swap off, sysctl...)
   - Installe k3s sur le node `server`
   - Récupère le token
   - Joint les agents au cluster

## Réseau

- Réseau privé : `10.0.1.0/24`
- Server : `10.0.1.10`
- Agents : `10.0.1.20` et `10.0.1.21`
- Communication inter-nodes via le réseau privé Hetzner

## Sécurité

- Firewall Hetzner limité aux ports nécessaires
- Possibilité d'activer fail2ban
- Token k3s généré dynamiquement
- Recommandation : restreindre le port 6443 à ton IP en production

## Évolutivité

Tu peux facilement :
- Augmenter le `count` des agents dans Terraform
- Ajouter un second server pour HA (nécessite etcd external ou k3s HA)
- Brancher un vrai LoadBalancer / MetalLB
- Ajouter Longhorn pour le stockage persistant
