---
title: "Portfolio webMethods - Infrastructure & DevOps"
author: "Aurelien NK"
date: "Février 2025"
subtitle: "Automatisation du déploiement Software AG webMethods Command Central"
lang: fr
geometry: margin=2.5cm
fontsize: 11pt
documentclass: article
header-includes:
  - \usepackage{fancyhdr}
  - \pagestyle{fancy}
  - \fancyhead[L]{Portfolio webMethods}
  - \fancyhead[R]{Aurelien NK}
  - \fancyfoot[C]{\thepage}
---

# Portfolio webMethods - Infrastructure & DevOps

**Candidat** : Aurelien NK
**Poste visé** : Développeur webMethods
**Documentation en ligne** : [https://nkaurelien.github.io/webmethods-devops-portfolio](https://nkaurelien.github.io/webmethods-devops-portfolio)
**Code source** : [https://github.com/nkaurelien/webmethods-devops-portfolio](https://github.com/nkaurelien/webmethods-devops-portfolio)

---

## Résumé exécutif

Ce document présente un projet personnel démontrant mes compétences en **développement webMethods** et **DevOps**. J'ai conçu et implémenté une infrastructure complète d'automatisation pour le déploiement de **Software AG webMethods Command Central** sur différents environnements (local et cloud).

### Points clés

- **Automatisation complète** : Déploiement sans intervention manuelle
- **Multi-environnement** : Docker, Vagrant (local) et AWS (cloud)
- **Infrastructure as Code** : Terraform + Ansible
- **Documentation** : Site MkDocs avec guides détaillés

---

## Objectifs du projet

1. **Approfondir mes connaissances** sur webMethods Command Central et l'écosystème Software AG
2. **Démontrer mes compétences DevOps** à travers l'automatisation infrastructure
3. **Créer une solution reproductible** pour le déploiement de la plateforme webMethods
4. **Documenter mon apprentissage** de manière professionnelle

---

## Compétences démontrées

### Software AG webMethods

| Compétence | Niveau | Détails |
|------------|--------|---------|
| Command Central (CCE) | Intermédiaire | Installation, configuration, administration |
| Platform Manager (SPM) | Intermédiaire | Gestion des noeuds, déploiements |
| CLI sagcc | Intermédiaire | Automatisation via ligne de commande |
| Architecture | Intermédiaire | Landscapes, environments, nodes |
| Licensing | Base | Import et gestion des licences |

### DevOps & Infrastructure

| Compétence | Niveau | Détails |
|------------|--------|---------|
| Terraform | Intermédiaire | Provisioning AWS, modules, providers |
| Ansible | Intermédiaire | Playbooks modulaires, idempotence |
| Docker | Avancé | Multi-stage, Compose, Supervisor |
| Vagrant | Intermédiaire | VMs reproductibles, provisioning |
| Shell scripting | Avancé | Bash, gestion d'erreurs, fonctions |
| Git | Avancé | Workflow, branches, historique |
| AWS | Intermédiaire | EC2, Security Groups, IAM |

---

## Architecture technique

### Vue d'ensemble

```
┌─────────────────────────────────────────────────────────────┐
│                    Options de déploiement                    │
├─────────────────┬─────────────────┬─────────────────────────┤
│   Docker        │   Vagrant       │   AWS (Terraform)       │
│   Compose       │   + Ansible     │   + Ansible             │
├─────────────────┴─────────────────┴─────────────────────────┤
│                    Plateforme webMethods                     │
│  ┌─────────────────┐    ┌─────────────────┐                 │
│  │ Command Central │    │ Platform Manager │                │
│  │   (CCE)         │◄──►│   (SPM)          │                │
│  │   :8090/:8091   │    │   :8092/:8093    │                │
│  └─────────────────┘    └─────────────────┘                 │
├─────────────────────────────────────────────────────────────┤
│                    Services supports                         │
│  ┌─────────────────┐    ┌─────────────────┐                 │
│  │   SQL Server    │    │    Keycloak     │                 │
│  │     :1433       │    │     :8585       │                 │
│  └─────────────────┘    └─────────────────┘                 │
└─────────────────────────────────────────────────────────────┘
```

### Stack technique

| Catégorie | Technologies |
|-----------|-------------|
| **Plateforme** | webMethods 10.15, Command Central, SPM |
| **IaC** | Terraform 1.2+, Ansible |
| **Containers** | Docker, Docker Compose, Supervisor |
| **Cloud** | AWS (EC2, Security Groups) |
| **Dev local** | Vagrant, VirtualBox |
| **Database** | SQL Server 2017 |
| **Auth** | Keycloak 26.1 |

---

## Réalisations détaillées

### 1. Containerisation Docker

J'ai créé **6 variantes de Dockerfiles** pour différents cas d'usage :

- **Ubuntu 22.04 + Supervisor** : Version production-ready
- **Oracle Linux 8** : Alternative enterprise
- **SPM standalone** : Pour les noeuds distants
- **RHEL 8, Windows, Systemd** : En développement

**Défi résolu** : Utilisation de **Supervisor** au lieu de systemd pour la gestion des processus dans les containers, car systemd nécessite des privilèges élevés incompatibles avec les bonnes pratiques Docker.

### 2. Playbooks Ansible

J'ai développé **3 playbooks** avec une complexité croissante (624 lignes au total) :

| Playbook | Lignes | Fonctionnalités |
|----------|--------|-----------------|
| `playbook.yml` | 136 | Installation basique |
| `playbook-with-supervisor.yml` | 238 | + Gestion des services |
| `playbook-with-supervisor-online.yml` | 250 | + Téléchargement installateur |

**Caractéristiques** :

- Idempotence garantie (exécution multiple sans effet de bord)
- Variables paramétrables
- Gestion des utilisateurs et permissions
- Configuration Supervisor automatique

### 3. Infrastructure Terraform

J'ai implémenté une **infrastructure AWS complète** :

- **EC2 Instance** : Ubuntu 22.04, t2.medium
- **Security Groups** : Ports webMethods (8090-8094), IS (5555), UM (9200)
- **Key Pair** : Gestion des clés SSH
- **Integration Ansible** : Exécution automatique du playbook post-création

**Innovation** : Utilisation du provider Terraform-Ansible pour une chaîne de déploiement entièrement automatisée.

### 4. Documentation MkDocs

J'ai créé un **site de documentation complet** avec :

- Architecture et diagrammes (Mermaid)
- Guides webMethods (CCE, SPM, CLI)
- Documentation DevOps (Terraform, Ansible, Docker, Vagrant)
- Journal d'apprentissage
- Guide de référence pour entretien

---

## Structure du projet

```
webmethods-devops-portfolio/
├── ansible/                          # Playbooks Ansible
│   ├── playbook.yml
│   ├── playbook-with-supervisor.yml
│   └── playbook-with-supervisor-online.yml
├── docker/                           # Dockerfiles
│   ├── Dockerfile.supervisor
│   ├── Dockerfile.supervisor.oraclelinux
│   └── Dockerfile.wmSpm.supervisor
├── terraform/                        # Infrastructure AWS
│   ├── main.tf
│   ├── variables.tf
│   ├── security.tf
│   ├── ansible.tf
│   └── data.tf
├── scripts/                          # Scripts de provisioning
│   ├── 00-setup-env.sh
│   ├── 01-import_licences.sh
│   └── cc-provision.sh
├── docs/                             # Documentation MkDocs
├── compose.yml                       # Docker Compose
├── Vagrantfile                       # Configuration Vagrant
└── mkdocs.yml                        # Configuration MkDocs
```

---

## Métriques du projet

| Métrique | Valeur |
|----------|--------|
| **Commits Git** | 22 |
| **Lignes de code** | 750+ |
| **Playbooks Ansible** | 624 lignes |
| **Scripts Shell** | 127 lignes |
| **Dockerfiles** | 6 variantes |
| **Modules Terraform** | 7 fichiers |
| **Pages documentation** | 12 |
| **Durée du projet** | ~2 semaines |

---

## Exemples de code

### Commande sagcc - Ajout d'un node

```bash
# Créer un node dans le landscape
sagcc create landscape nodes \
    name="Production IS 1" \
    alias=prodIs1 \
    url=http://prod-is1:8092

# Configurer les credentials
sagcc add security credentials \
    nodeAlias=prodIs1 \
    runtimeComponentId=SPM-CONNECTION \
    authenticationType=BASIC \
    username=Administrator \
    password=manage123

# Vérifier le status
sagcc get landscape nodes prodIs1 status
```

### Extrait Ansible - Installation webMethods

```yaml
- name: Run Command Central installer
  become: yes
  become_user: "{{ username }}"
  shell: |
    {{ installer_path }} \
      -d {{ sag_home }} \
      -H {{ ansible_hostname }} \
      -c {{ cce_http_port }} \
      -C {{ cce_https_port }} \
      -s {{ spm_http_port }} \
      -S {{ spm_https_port }} \
      -p {{ cc_admin_password }} \
      --accept-license
  args:
    creates: "{{ sag_home }}/.installer_run"
```

### Extrait Terraform - Instance EC2

```hcl
resource "aws_instance" "sag_cc_spm_server" {
  ami           = data.aws_ami.ubuntu22canonical.id
  instance_type = "t2.medium"
  key_name      = aws_key_pair.deployer.key_name

  vpc_security_group_ids = [
    aws_security_group.cc-spm-security-group.id
  ]

  tags = {
    Name        = "webmethods-cc-server"
    Environment = "Development"
  }
}
```

---

## Parcours d'apprentissage

### Chronologie

| Période | Phase | Réalisations |
|---------|-------|--------------|
| 3-8 Fév | Containerisation | Docker, Supervisor, multi-images |
| 8-9 Fév | Documentation | Guides installation, HELP.md |
| 9-14 Fév | Orchestration | Ansible playbooks, Vagrant |
| 15-16 Fév | Infrastructure | Terraform AWS, intégration complète |

### Problèmes résolus

1. **Systemd dans Docker** → Solution : Supervisor comme init system
2. **Permissions fichiers** → Solution : UID/GID fixes (1234)
3. **Idempotence Ansible** → Solution : Flag files et conditions
4. **Intégration Terraform-Ansible** → Solution : Provider jdziat/ansible

---

## Prochaines étapes envisagées

- [ ] Haute disponibilité : Cluster CCE avec load balancer
- [ ] CI/CD : Pipeline GitHub Actions pour déploiement continu
- [ ] Monitoring : Intégration Prometheus/Grafana
- [ ] Secrets : HashiCorp Vault pour credentials
- [ ] Templates : Provisioning automatisé IS/UM/TN

---

## Conclusion

Ce projet démontre ma capacité à :

1. **Apprendre en autonomie** une technologie enterprise (webMethods)
2. **Appliquer les meilleures pratiques DevOps** (IaC, automatisation, documentation)
3. **Résoudre des problèmes techniques** complexes
4. **Documenter mon travail** de manière professionnelle

Je suis motivé pour approfondir mes compétences webMethods dans un contexte professionnel et contribuer à des projets d'intégration enterprise.

---

## Liens

- **Documentation complète** : [https://nkaurelien.github.io/webmethods-devops-portfolio](https://nkaurelien.github.io/webmethods-devops-portfolio)
- **Code source** : [https://github.com/nkaurelien/webmethods-devops-portfolio](https://github.com/nkaurelien/webmethods-devops-portfolio)
- **LinkedIn** : [https://linkedin.com/in/nkaurelien](https://linkedin.com/in/nkaurelien)
- **GitHub** : [https://github.com/nkaurelien](https://github.com/nkaurelien)

---

*Document généré le : Février 2025*
