# k3s-terraform-ansible

**Cluster Kubernetes minimal (k3s) entièrement automatisé avec Terraform + Ansible sur Proxmox.**

Projet de portfolio sysadmin / DevOps / Homelab.

Ce dépôt permet de provisionner et configurer un cluster Kubernetes léger (k3s) de façon 100 % automatisée :

- **Terraform** : crée les VMs sur **Proxmox**
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

---

## Prérequis

### Côté Proxmox
- Un hyperviseur Proxmox fonctionnel
- Un **template cloud-init Ubuntu 24.04** (VMID à renseigner)
- Bridge réseau (généralement `vmbr0`)
- Accès API (utilisateur + mot de passe ou token)

### Outils locaux
- Terraform >= 1.5
- Ansible >= 2.14
- Clé SSH

---

## Structure du dépôt

```
.
├── ansible/
│   ├── inventory/
│   ├── group_vars/
│   ├── playbooks/
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
├── .gitignore
└── README.md
```

---

## Déploiement rapide

### 1. Préparer un template cloud-init sur Proxmox

Crée une VM Ubuntu 24.04 cloud-init, installe `qemu-guest-agent`, convertis-la en template, et note son **VMID** (ex: 9000).

### 2. Configurer Terraform

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
# Édite avec tes infos Proxmox + template_id + clé SSH
```

### 3. Provisionner les VMs

```bash
terraform init
terraform plan
terraform apply
```

### 4. Configurer l'inventaire Ansible

```bash
cd ../ansible
cp inventory/hosts.yml.example inventory/hosts.yml
```

Remplis avec les IPs (par défaut `192.168.1.110` / `.111` / `.112` — modifie dans `terraform/main.tf` si besoin).

**Important** : l'utilisateur est `ubuntu` (pas root).

### 5. Lancer le déploiement k3s

```bash
ansible-playbook -i inventory/hosts.yml playbooks/site.yml
```

### 6. Récupérer le kubeconfig

```bash
scp ubuntu@192.168.1.110:/etc/rancher/k3s/k3s.yaml ~/.kube/config
# Remplace 127.0.0.1 par l'IP du server
```

```bash
kubectl get nodes
kubectl get pods -A
```

---

## Personnalisation

- Change les IPs dans `terraform/main.tf` (bloc `locals`)
- Ajuste CPU / RAM / disque dans `terraform.tfvars`
- Version de k3s dans `ansible/group_vars/all.yml`

---

## Sécurité

- Pas de secrets dans le dépôt
- Utilisateur `ubuntu` + clé SSH
- fail2ban activable
- Recommandé : restreindre l'accès API Proxmox et le port 6443

---

## Améliorations possibles

- [ ] Support multi-nœuds Proxmox
- [ ] IP flottante / MetalLB
- [ ] Stack monitoring (Prometheus + Grafana)
- [ ] GitOps (ArgoCD / Flux)
- [ ] Hardening CIS
- [ ] Snapshot automatique des VMs

---

## Auteur

Portfolio sysadmin — Homelab, Proxmox, Kubernetes, Automation, Infrastructure as Code.
