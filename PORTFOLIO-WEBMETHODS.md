---
title: "Portfolio webMethods - Infrastructure et DevOps"
author: "Aurelien NK"
date: "Fevrier 2025"
subtitle: "Automatisation du deploiement Software AG webMethods Command Central"
lang: fr
geometry: margin=2.5cm
fontsize: 11pt
documentclass: article
header-includes:
  - \usepackage[utf8]{inputenc}
  - \usepackage[T1]{fontenc}
  - \usepackage{fancyhdr}
  - \pagestyle{fancy}
  - \fancyhead[L]{Portfolio webMethods}
  - \fancyhead[R]{Aurelien NK}
  - \fancyfoot[C]{\thepage}
---

# Portfolio webMethods - Infrastructure et DevOps

**Candidat** : Aurelien NK
**Poste vise** : Developpeur webMethods
**Documentation en ligne** : https://nkaurelien.github.io/webmethods-devops-portfolio
**Code source** : https://github.com/nkaurelien/webmethods-devops-portfolio

---

## Resume executif

Ce document presente un projet personnel demontrant mes competences en **developpement webMethods** et **DevOps**. J'ai concu et implemente une infrastructure complete d'automatisation pour le deploiement de **Software AG webMethods Command Central** sur differents environnements (local et cloud).

### Points cles

- **Automatisation complete** : Deploiement sans intervention manuelle
- **Multi-environnement** : Docker, Vagrant (local) et AWS (cloud)
- **Infrastructure as Code** : Terraform + Ansible
- **Documentation** : Site MkDocs avec guides detailles

---

## Objectifs du projet

1. **Approfondir mes connaissances** sur webMethods Command Central et l'ecosysteme Software AG
2. **Demontrer mes competences DevOps** a travers l'automatisation infrastructure
3. **Creer une solution reproductible** pour le deploiement de la plateforme webMethods
4. **Documenter mon apprentissage** de maniere professionnelle

---

## Competences demontrees

### Software AG webMethods

| Competence | Niveau | Details |
|------------|--------|---------|
| Command Central (CCE) | Intermediaire | Installation, configuration, administration |
| Platform Manager (SPM) | Intermediaire | Gestion des noeuds, deploiements |
| CLI sagcc | Intermediaire | Automatisation via ligne de commande |
| Architecture | Intermediaire | Landscapes, environments, nodes |
| Licensing | Base | Import et gestion des licences |

### DevOps et Infrastructure

| Competence | Niveau | Details |
|------------|--------|---------|
| Terraform | Intermediaire | Provisioning AWS, modules, providers |
| Ansible | Intermediaire | Playbooks modulaires, idempotence |
| Docker | Avance | Multi-stage, Compose, Supervisor |
| Vagrant | Intermediaire | VMs reproductibles, provisioning |
| Shell scripting | Avance | Bash, gestion d'erreurs, fonctions |
| Git | Avance | Workflow, branches, historique |
| AWS | Intermediaire | EC2, Security Groups, IAM |

---

## Architecture technique

### Vue d'ensemble

```
+-------------------------------------------------------------+
|                    Options de deploiement                    |
+-----------------+-----------------+-------------------------+
|   Docker        |   Vagrant       |   AWS (Terraform)       |
|   Compose       |   + Ansible     |   + Ansible             |
+-----------------+-----------------+-------------------------+
|                    Plateforme webMethods                     |
|  +-------------------+    +--------------------+             |
|  | Command Central   |<-->| Platform Manager   |             |
|  |   (CCE)           |    |   (SPM)            |             |
|  |   :8090/:8091     |    |   :8092/:8093      |             |
|  +-------------------+    +--------------------+             |
+-------------------------------------------------------------+
|                    Services supports                         |
|  +-------------------+    +--------------------+             |
|  |   SQL Server      |    |    Keycloak        |             |
|  |     :1433         |    |     :8585          |             |
|  +-------------------+    +--------------------+             |
+-------------------------------------------------------------+
```

### Stack technique

| Categorie | Technologies |
|-----------|-------------|
| **Plateforme** | webMethods 10.15, Command Central, SPM |
| **IaC** | Terraform 1.2+, Ansible |
| **Containers** | Docker, Docker Compose, Supervisor |
| **Cloud** | AWS (EC2, Security Groups) |
| **Dev local** | Vagrant, VirtualBox |
| **Database** | SQL Server 2017 |
| **Auth** | Keycloak 26.1 |

---

## Realisations detaillees

### 1. Containerisation Docker

J'ai cree **6 variantes de Dockerfiles** pour differents cas d'usage :

- **Ubuntu 22.04 + Supervisor** : Version production-ready
- **Oracle Linux 8** : Alternative enterprise
- **SPM standalone** : Pour les noeuds distants
- **RHEL 8, Windows, Systemd** : En developpement

**Defi resolu** : Utilisation de **Supervisor** au lieu de systemd pour la gestion des processus dans les containers, car systemd necessite des privileges eleves incompatibles avec les bonnes pratiques Docker.

### 2. Playbooks Ansible

J'ai developpe **3 playbooks** avec une complexite croissante (624 lignes au total) :

| Playbook | Lignes | Fonctionnalites |
|----------|--------|-----------------|
| playbook.yml | 136 | Installation basique |
| playbook-with-supervisor.yml | 238 | + Gestion des services |
| playbook-with-supervisor-online.yml | 250 | + Telechargement installateur |

**Caracteristiques** :

- Idempotence garantie (execution multiple sans effet de bord)
- Variables parametrables
- Gestion des utilisateurs et permissions
- Configuration Supervisor automatique

### 3. Infrastructure Terraform

J'ai implemente une **infrastructure AWS complete** :

- **EC2 Instance** : Ubuntu 22.04, t2.medium
- **Security Groups** : Ports webMethods (8090-8094), IS (5555), UM (9200)
- **Key Pair** : Gestion des cles SSH
- **Integration Ansible** : Execution automatique du playbook post-creation

**Innovation** : Utilisation du provider Terraform-Ansible pour une chaine de deploiement entierement automatisee.

### 4. Documentation MkDocs

J'ai cree un **site de documentation complet** avec :

- Architecture et diagrammes (Mermaid)
- Guides webMethods (CCE, SPM, CLI)
- Documentation DevOps (Terraform, Ansible, Docker, Vagrant)
- Journal d'apprentissage
- Guide de reference pour entretien

---

## Structure du projet

```
webmethods-devops-portfolio/
|-- ansible/                          # Playbooks Ansible
|   |-- playbook.yml
|   |-- playbook-with-supervisor.yml
|   +-- playbook-with-supervisor-online.yml
|-- docker/                           # Dockerfiles
|   |-- Dockerfile.supervisor
|   |-- Dockerfile.supervisor.oraclelinux
|   +-- Dockerfile.wmSpm.supervisor
|-- terraform/                        # Infrastructure AWS
|   |-- main.tf
|   |-- variables.tf
|   |-- security.tf
|   |-- ansible.tf
|   +-- data.tf
|-- scripts/                          # Scripts de provisioning
|   |-- 00-setup-env.sh
|   |-- 01-import_licences.sh
|   +-- cc-provision.sh
|-- docs/                             # Documentation MkDocs
|-- compose.yml                       # Docker Compose
|-- Vagrantfile                       # Configuration Vagrant
+-- mkdocs.yml                        # Configuration MkDocs
```

---

## Metriques du projet

| Metrique | Valeur |
|----------|--------|
| **Commits Git** | 22 |
| **Lignes de code** | 750+ |
| **Playbooks Ansible** | 624 lignes |
| **Scripts Shell** | 127 lignes |
| **Dockerfiles** | 6 variantes |
| **Modules Terraform** | 7 fichiers |
| **Pages documentation** | 12 |
| **Duree du projet** | environ 2 semaines |

---

## Exemples de code

### Commande sagcc - Ajout d'un node

```bash
# Creer un node dans le landscape
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

# Verifier le status
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

| Periode | Phase | Realisations |
|---------|-------|--------------|
| 3-8 Fev | Containerisation | Docker, Supervisor, multi-images |
| 8-9 Fev | Documentation | Guides installation, HELP.md |
| 9-14 Fev | Orchestration | Ansible playbooks, Vagrant |
| 15-16 Fev | Infrastructure | Terraform AWS, integration complete |

### Problemes resolus

1. **Systemd dans Docker** - Solution : Supervisor comme init system
2. **Permissions fichiers** - Solution : UID/GID fixes (1234)
3. **Idempotence Ansible** - Solution : Flag files et conditions
4. **Integration Terraform-Ansible** - Solution : Provider jdziat/ansible

---

## Prochaines etapes envisagees

- Haute disponibilite : Cluster CCE avec load balancer
- CI/CD : Pipeline GitHub Actions pour deploiement continu
- Monitoring : Integration Prometheus/Grafana
- Secrets : HashiCorp Vault pour credentials
- Templates : Provisioning automatise IS/UM/TN

---

## Conclusion

Ce projet demontre ma capacite a :

1. **Apprendre en autonomie** une technologie enterprise (webMethods)
2. **Appliquer les meilleures pratiques DevOps** (IaC, automatisation, documentation)
3. **Resoudre des problemes techniques** complexes
4. **Documenter mon travail** de maniere professionnelle

Je suis motive pour approfondir mes competences webMethods dans un contexte professionnel et contribuer a des projets d'integration enterprise.

---

## Liens

- **Documentation complete** : https://nkaurelien.github.io/webmethods-devops-portfolio
- **Code source** : https://github.com/nkaurelien/webmethods-devops-portfolio
- **LinkedIn** : https://linkedin.com/in/nkaurelien
- **GitHub** : https://github.com/nkaurelien

---

*Document genere le : Fevrier 2025*
