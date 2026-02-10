# Command Central (CCE)

## Presentation

**Software AG Command Central** est la console d'administration centralisee pour tous les produits Software AG. Elle permet de :

- Installer et mettre a jour les produits
- Configurer les instances
- Monitorer la sante des services
- Gerer les licences
- Automatiser les operations via CLI/API

---

## Installation realisee

### Methode d'installation

```bash
# Execution de l'installateur
./cc-def-10.15-fix8-lnxamd64.sh \
    -d /opt/SAGCommandCentral \       # Repertoire cible
    -H localhost \                     # Hostname
    -c 8090 \                          # CCE HTTP port
    -C 8091 \                          # CCE HTTPS port
    -s 8092 \                          # SPM HTTP port
    -S 8093 \                          # SPM HTTPS port
    -p manage123 \                     # Mot de passe admin
    --accept-license                   # Acceptation licence
```

### Structure installee

```
/opt/SAGCommandCentral/
├── CommandCentral/
│   ├── client/
│   │   └── bin/
│   │       └── sagcc              # CLI principal
│   ├── server/
│   └── appserver/
├── profiles/
│   ├── CCE/                       # Profil Command Central Engine
│   │   ├── bin/
│   │   │   ├── startup.sh
│   │   │   └── shutdown.sh
│   │   ├── configuration/
│   │   └── logs/
│   └── SPM/                       # Profil Platform Manager
│       ├── bin/
│       ├── configuration/
│       └── logs/
├── common/                        # Librairies partagees
├── install/                       # Logs installation
└── jvm/                          # JVM embarquee
```

---

## Interface Web

### Acces

| Type | URL |
|------|-----|
| HTTP | `http://localhost:8090/cce/web` |
| HTTPS | `https://localhost:8091/cce/web` |

### Credentials par defaut

```
Username: Administrator
Password: manage123
```

### Fonctionnalites principales

1. **Dashboard** - Vue d'ensemble de la sante
2. **Installations** - Gestion des produits installes
3. **Environments** - Organisation des nodes
4. **Repositories** - Sources de produits
5. **Jobs** - Historique des operations
6. **Monitoring** - Metriques et alertes

---

## CLI sagcc

### Configuration de l'environnement

```bash
# Variables d'environnement
export SAG_HOME=/opt/SAGCommandCentral
export CC_CLI_HOME=$SAG_HOME/CommandCentral/client
export PATH=$PATH:$CC_CLI_HOME/bin

# OU sourcer le profile
source $SAG_HOME/profiles/CCE/bin/sagccEnv.sh
```

### Commandes essentielles

#### Gestion des licences

```bash
# Importer des licences
sagcc add license-tools keys -i /path/to/licences.zip

# Lister les licences
sagcc list license-tools keys

# Verifier une licence
sagcc get license-tools keys <key-alias>
```

#### Gestion des repositories

```bash
# Ajouter un repository produit (image)
sagcc add repository products image \
    name=wM10.15-products \
    -i /path/to/wM10_15.zip

# Ajouter un mirror
sagcc add repository products mirror \
    name=wM10.15-mirror \
    sourceRepos=wM10.15-products

# Lister les repositories
sagcc list repository products

# Ajouter un repository de fixes
sagcc add repository fixes image \
    name=wM10.15-fixes \
    -i /path/to/fixes.zip
```

#### Gestion du landscape

```bash
# Creer un node
sagcc create landscape nodes \
    name="Integration Server 1" \
    alias=wmIsServer1 \
    url=http://is-host:8092

# Lister les nodes
sagcc list landscape nodes

# Verifier la connectivite
sagcc get landscape nodes wmIsServer1 status
```

#### Gestion des environments

```bash
# Creer un environment
sagcc add landscape environments \
    alias=PROD_ESB_10.15

# Attacher un node a un environment
sagcc add landscape environments PROD_ESB_10.15 nodes \
    nodeAlias=wmIsServer1

# Lister les environments
sagcc list landscape environments
```

#### Configuration securite

```bash
# Ajouter des credentials pour un node
sagcc add security credentials \
    nodeAlias=wmIsServer1 \
    runtimeComponentId=SPM-CONNECTION \
    authenticationType=BASIC \
    username=Administrator \
    password=manage123
```

---

## API REST

### Endpoints principaux

| Endpoint | Description |
|----------|-------------|
| `/sag/cce/v1/landscape/nodes` | Gestion des nodes |
| `/sag/cce/v1/landscape/environments` | Gestion des environments |
| `/sag/cce/v1/repository/products` | Repositories produits |
| `/sag/cce/v1/license/keys` | Gestion licences |
| `/sag/cce/v1/jobs` | Operations asynchrones |

### Exemple d'appel API

```bash
# Lister les nodes
curl -u Administrator:manage123 \
    http://localhost:8090/sag/cce/v1/landscape/nodes

# Creer un node
curl -X POST \
    -u Administrator:manage123 \
    -H "Content-Type: application/json" \
    -d '{"alias":"newNode","url":"http://host:8092"}' \
    http://localhost:8090/sag/cce/v1/landscape/nodes
```

---

## Automatisation realisee

### Script de provisioning

```bash
#!/bin/bash
# cc-provision.sh - Extrait

# Fonctions implementees
update_package_list()        # apt-get update
create_user()                # Creation wmuser
copy_ssh_keys()              # Copie cles SSH
allow_sudo_without_password()# Configuration sudoers
create_directories()         # Structure repertoires
set_installer_permissions()  # chmod installer
create_profile_files()       # .bashrc, .profile
run_installer()              # Execution installation
append_sag_environment()     # Variables SAG
create_start_script()        # Script demarrage
```

### Integration Ansible

```yaml
# Extrait playbook
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

---

## Troubleshooting

### Logs importants

```bash
# Logs CCE
tail -f /opt/SAGCommandCentral/profiles/CCE/logs/wrapper.log

# Logs installation
cat /opt/SAGCommandCentral/install/logs/installLog.txt

# Logs Supervisor (si utilise)
tail -f /var/log/supervisor/cce.log
```

### Problemes courants

| Probleme | Cause | Solution |
|----------|-------|----------|
| Port 8090 occupe | Autre service | `lsof -i :8090` puis stopper |
| Erreur memoire | JVM trop petite | Augmenter heap dans `wrapper.conf` |
| Connection SPM refused | SPM pas demarre | Verifier `supervisorctl status` |
| License invalide | Expiration ou hostname | Reimporter licence valide |

### Verification sante

```bash
# Status services
supervisorctl status

# Test connectivite CCE
curl -s http://localhost:8090/sag/cce/v1/health

# Test CLI
sagcc list landscape nodes
```
