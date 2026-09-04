# k3s-terraform-ansible

**Cluster Kubernetes minimal (k3s) entièrement automatisé avec Terraform + Ansible.**

Projet de portfolio sysadmin / DevOps.

Ce dépôt permet de provisionner et configurer un cluster Kubernetes léger (k3s) de façon 100 % automatisée :

- **Terraform** : provisionne l'infrastructure (VMs)
- **Ansible** : installe et configure k3s (server + agents)

---

## Architecture cible

```
                    +-------------------+
                    |   Control Plane   |
                    |     (k3s server)  |
                    |   + Traefik       |
                    +---------+---------+
                              |
              +---------------+---------------+
              |                               |
     +--------v--------+             +--------v--------+
     |   Worker Node 1 |             |   Worker Node 2 |
     |   (k3s agent)   |             |   (k3s agent)   |
     +-----------------+             +-----------------+
```

- 1 node `server` (control-plane)
- 2 nodes `agent` (workers)
- CNI : Flannel (par défaut k3s)
- Ingress : Traefik (inclus dans k3s)
- Compatible avec un usage lab / démo / portfolio

---

## Prérequis

### Outils locaux
- Terraform >= 1.5
- Ansible >= 2.14
- `ssh` + clé SSH
- Compte cloud (exemple fourni pour **Hetzner Cloud**)

### Côté infrastructure
- 3 VMs (minimum 2 vCPU / 2 Go RAM recommandé pour le server)
- Accès SSH root ou utilisateur sudo
- Ports ouverts : 22, 6443, 10250, et flannel (UDP 8472)

---

## Structure du dépôt

```
.
├── ansible/
│   ├── inventory/
│   │   └── hosts.yml.example
│   ├── group_vars/
│   │   └── all.yml
│   ├── playbooks/
│   │   └── site.yml
│   └── roles/
│       ├── common/
│       ├── k3s_server/
│       └── k3s_agent/
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── providers.tf
│   └── terraform.tfvars.example
├── docs/
│   └── architecture.md
├── .gitignore
└── README.md
```

---

## Déploiement rapide

### 1. Cloner le dépôt

```bash
git clone https://github.com/w7zk0/k3s-terraform-ansible.git
cd k3s-terraform-ansible
```

### 2. Provisionner l'infrastructure (Terraform)

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
# Édite terraform.tfvars avec tes tokens / clés SSH

terraform init
terraform plan
terraform apply
```

Les outputs te donneront les IPs des machines.

### 3. Préparer l'inventaire Ansible

```bash
cd ../ansible
cp inventory/hosts.yml.example inventory/hosts.yml
# Remplis avec les IPs sorties par Terraform
```

### 4. Lancer le déploiement k3s

```bash
ansible-playbook -i inventory/hosts.yml playbooks/site.yml
```

### 5. Récupérer le kubeconfig

```bash
# Sur le node server
scp root@<IP_SERVER>:/etc/rancher/k3s/k3s.yaml ~/.kube/config
# Remplace 127.0.0.1 par l'IP publique du server
```

Puis :

```bash
kubectl get nodes
kubectl get pods -A
```

---

## Fonctionnalités incluses

- Installation automatisée de k3s (server + agents)
- Configuration sécurisée de base (disable cloud provider, etc.)
- Rôle `common` : updates, timezone, packages de base, fail2ban optionnel
- Génération automatique du token et jointure des agents
- Support multi-nodes propre
- Idempotent (rejouable)

---

## Personnalisation

Tu peux facilement :
- Ajouter des nodes agents
- Changer la version de k3s
- Activer/désactiver Traefik, ServiceLB, etc.
- Ajouter un role pour MetalLB, Longhorn, monitoring (Prometheus), etc.

Voir `ansible/group_vars/all.yml` et les variables des rôles.

---

## Sécurité (bonnes pratiques appliquées)

- Pas de secrets en clair dans le dépôt
- Utilisation de variables Ansible / Terraform
- Recommandation d'utiliser un bastion ou WireGuard en production
- k3s tournant avec les options de sécurité raisonnables pour un lab

---

## Améliorations possibles (idées portfolio)

- [ ] Ajouter un module Terraform pour Hetzner / AWS / Proxmox
- [ ] Intégrer ArgoCD (GitOps)
- [ ] Stack monitoring (Prometheus + Grafana)
- [ ] Backup automatisé (Velero ou k3s etcd snapshots)
- [ ] CI (GitHub Actions) qui valide Terraform + Ansible
- [ ] Hardening CIS sur les nodes

---

## Auteur

Portfolio sysadmin — automatisation, Linux, Kubernetes, Infrastructure as Code.

N'hésite pas à forker, améliorer et proposer des PR.
