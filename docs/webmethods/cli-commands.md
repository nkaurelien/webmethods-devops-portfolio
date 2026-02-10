# CLI sagcc - Reference des commandes

## Configuration initiale

### Variables d'environnement

```bash
# Methode 1: Variables manuelles
export SAG_HOME=/opt/SAGCommandCentral
export CC_CLI_HOME=$SAG_HOME/CommandCentral/client
export PATH=$PATH:$CC_CLI_HOME/bin

# Methode 2: Sourcer le profile
source $SAG_HOME/profiles/CCE/bin/sagccEnv.sh
```

### Connexion par defaut

```bash
# Le CLI utilise par defaut
# URL: http://localhost:8090
# User: Administrator
# Password: (demande interactive)

# Specifier explicitement
sagcc list landscape nodes \
    -h localhost \
    -p 8090 \
    -u Administrator \
    -x manage123
```

---

## Commandes par categorie

### Licenses

```bash
# Lister les licences
sagcc list license-tools keys

# Importer une licence
sagcc add license-tools keys -i /path/to/license.zip

# Exporter une licence
sagcc get license-tools keys <alias> -o /path/to/export.xml

# Supprimer une licence
sagcc delete license-tools keys <alias>

# Details d'une licence
sagcc get license-tools keys <alias>
```

---

### Repositories

#### Repositories Produits

```bash
# Lister les repos
sagcc list repository products

# Ajouter un repo image (fichier local)
sagcc add repository products image \
    name=wM10.15-products \
    -i /path/to/products.zip

# Ajouter un repo mirror
sagcc add repository products mirror \
    name=wM10.15-mirror \
    sourceRepos=wM10.15-products

# Ajouter un repo Empower (en ligne)
sagcc add repository products webm \
    name=webm-repo \
    url=https://sdc.softwareag.com/... \
    username=empower-user \
    password=empower-pass

# Supprimer un repo
sagcc delete repository products <name>
```

#### Repositories Fixes

```bash
# Lister les repos fixes
sagcc list repository fixes

# Ajouter un repo fixes
sagcc add repository fixes image \
    name=wM10.15-fixes \
    -i /path/to/fixes.zip

# Lister les fixes disponibles
sagcc list repository fixes products <repo-name>
```

---

### Landscape - Nodes

```bash
# Lister tous les nodes
sagcc list landscape nodes

# Details d'un node
sagcc get landscape nodes <alias>

# Creer un node
sagcc create landscape nodes \
    name="Integration Server 1" \
    alias=is1 \
    url=http://is1-host:8092

# Modifier un node
sagcc update landscape nodes <alias> \
    url=https://is1-host:8093

# Supprimer un node
sagcc delete landscape nodes <alias>

# Status d'un node
sagcc get landscape nodes <alias> status

# Ping un node
sagcc exec landscape nodes <alias> ping
```

---

### Landscape - Environments

```bash
# Lister les environments
sagcc list landscape environments

# Creer un environment
sagcc add landscape environments \
    alias=PROD_ESB \
    name="Production ESB Environment"

# Ajouter un node a un environment
sagcc add landscape environments PROD_ESB nodes \
    nodeAlias=is1

# Lister les nodes d'un environment
sagcc list landscape environments PROD_ESB nodes

# Retirer un node
sagcc delete landscape environments PROD_ESB nodes is1

# Supprimer un environment
sagcc delete landscape environments PROD_ESB
```

---

### Security - Credentials

```bash
# Lister les credentials
sagcc list security credentials

# Ajouter des credentials pour un node
sagcc add security credentials \
    nodeAlias=is1 \
    runtimeComponentId=SPM-CONNECTION \
    authenticationType=BASIC \
    username=Administrator \
    password=manage123

# Credentials pour acces database
sagcc add security credentials \
    alias=db-creds \
    runtimeComponentId=COMMON-JDBC \
    authenticationType=BASIC \
    username=sa \
    password=SqlPass123

# Modifier des credentials
sagcc update security credentials <alias> \
    password=newPassword

# Supprimer
sagcc delete security credentials <alias>
```

---

### Inventory

```bash
# Lister les produits installes sur un node
sagcc list inventory products nodeAlias=is1

# Lister les fixes installes
sagcc list inventory fixes nodeAlias=is1

# Lister les runtimes
sagcc list inventory runtimes nodeAlias=is1

# Details d'un produit
sagcc get inventory products nodeAlias=is1 productId=IS

# Composants d'un runtime
sagcc list inventory components nodeAlias=is1 runtimeId=OSGI-IS_default
```

---

### Lifecycle (Demarrage/Arret)

```bash
# Demarrer un runtime
sagcc exec lifecycle runtimes <nodeAlias> <runtimeId> start

# Arreter un runtime
sagcc exec lifecycle runtimes <nodeAlias> <runtimeId> stop

# Redemarrer
sagcc exec lifecycle runtimes <nodeAlias> <runtimeId> restart

# Exemples concrets
sagcc exec lifecycle runtimes is1 OSGI-IS_default start
sagcc exec lifecycle runtimes is1 OSGI-UM_default stop
```

---

### Monitoring

```bash
# Status d'un runtime
sagcc get monitoring runtimestatus <nodeAlias> <runtimeId>

# Status de tous les runtimes d'un node
sagcc list monitoring runtimestatus <nodeAlias>

# Metriques
sagcc get monitoring metrics <nodeAlias> <runtimeId>

# Alertes
sagcc list monitoring alerts
```

---

### Provisioning

```bash
# Appliquer un template
sagcc exec provisioning composite apply \
    nodeAlias=is1 \
    template=is-layer \
    repo.product=wM10.15-products \
    repo.fix=wM10.15-fixes

# Lister les templates disponibles
sagcc list provisioning templates

# Exporter un template
sagcc get provisioning templates <template-id> \
    -o /path/to/template.yaml

# Importer un template
sagcc add provisioning templates -i /path/to/template.yaml
```

---

### Jobs (Operations asynchrones)

```bash
# Lister les jobs recents
sagcc list jobmanager jobs

# Details d'un job
sagcc get jobmanager jobs <job-id>

# Annuler un job
sagcc exec jobmanager jobs <job-id> cancel

# Attendre la fin d'un job
sagcc exec jobmanager jobs <job-id> wait
```

---

## Exemples de workflows complets

### Workflow 1: Ajouter un nouveau serveur IS

```bash
#!/bin/bash
# add-is-server.sh

NODE_ALIAS="prodIs2"
NODE_HOST="prod-is2.example.com"
ADMIN_PASS="manage123"

# 1. Creer le node
sagcc create landscape nodes \
    name="Production IS 2" \
    alias=$NODE_ALIAS \
    url=http://$NODE_HOST:8092

# 2. Configurer les credentials
sagcc add security credentials \
    nodeAlias=$NODE_ALIAS \
    runtimeComponentId=SPM-CONNECTION \
    authenticationType=BASIC \
    username=Administrator \
    password=$ADMIN_PASS

# 3. Verifier la connexion
sagcc get landscape nodes $NODE_ALIAS status

# 4. Ajouter a l'environment
sagcc add landscape environments PROD_ESB nodes \
    nodeAlias=$NODE_ALIAS

echo "Node $NODE_ALIAS added successfully"
```

### Workflow 2: Deployer IS sur un node

```bash
#!/bin/bash
# deploy-is.sh

NODE_ALIAS="prodIs2"

# 1. Verifier les repos
sagcc list repository products
sagcc list repository fixes

# 2. Appliquer le template IS
JOB_ID=$(sagcc exec provisioning composite apply \
    nodeAlias=$NODE_ALIAS \
    template=is-layer \
    repo.product=wM10.15-products \
    repo.fix=wM10.15-fixes \
    -f json | jq -r '.jobId')

echo "Job started: $JOB_ID"

# 3. Attendre la fin
sagcc exec jobmanager jobs $JOB_ID wait

# 4. Verifier l'installation
sagcc list inventory products nodeAlias=$NODE_ALIAS

# 5. Demarrer IS
sagcc exec lifecycle runtimes $NODE_ALIAS OSGI-IS_default start
```

---

## Options globales

| Option | Description |
|--------|-------------|
| `-h, --host` | Hostname CCE (defaut: localhost) |
| `-p, --port` | Port CCE (defaut: 8090) |
| `-u, --user` | Username (defaut: Administrator) |
| `-x, --password` | Password |
| `-f, --format` | Format sortie: text, json, xml |
| `-o, --output` | Fichier de sortie |
| `-i, --input` | Fichier d'entree |
| `-v, --verbose` | Mode verbeux |
| `--wait` | Attendre la fin des jobs |

---

## Astuces

### Output JSON pour scripting

```bash
# Parser avec jq
sagcc list landscape nodes -f json | jq '.[] | .alias'

# Compter les nodes
sagcc list landscape nodes -f json | jq 'length'
```

### Boucle sur les nodes

```bash
for node in $(sagcc list landscape nodes -f json | jq -r '.[].alias'); do
    echo "Checking $node..."
    sagcc get landscape nodes $node status
done
```

### Alias utiles

```bash
# Dans .bashrc
alias sagcc-nodes='sagcc list landscape nodes'
alias sagcc-status='sagcc get landscape nodes local status'
alias sagcc-jobs='sagcc list jobmanager jobs'
```
