# Guide d'entretien - Cheat Sheet

!!! tip "Objectif de ce guide"
    Reference rapide pour defendre votre candidature lors de l'entretien pour le poste de **Developpeur webMethods**.

---

## Pitch de presentation (30 secondes)

> "Je suis ingenieur logiciel et DevOps avec une solide experience en developpement et automatisation. J'ai travaille avec webMethods Designer par le passe, et recemment j'ai approfondi mes competences en creant un projet complet d'automatisation de deploiement pour Command Central. Ce projet combine Terraform, Ansible et Docker pour deployer webMethods sur AWS de maniere entierement automatisee."

---

## Questions techniques probables

### webMethods

#### "Qu'est-ce que Command Central ?"

> Command Central est la **console d'administration centralisee** de Software AG. Elle permet de :
>
> - Installer et mettre a jour les produits (IS, UM, TN...)
> - Configurer les instances a distance
> - Monitorer la sante de l'infrastructure
> - Automatiser les operations via CLI (`sagcc`) ou API REST

#### "Quelle est la difference entre CCE et SPM ?"

| CCE (Command Central Engine) | SPM (Platform Manager) |
|------------------------------|------------------------|
| Console centrale | Agent local |
| Un seul par landscape | Un par serveur |
| Interface web + API | Pas d'interface |
| Envoie les commandes | Execute les commandes |
| Ports 8090/8091 | Ports 8092/8093 |

#### "Quels produits webMethods connaissez-vous ?"

- **Integration Server (IS)** : Serveur d'integration, services REST/SOAP
- **Universal Messaging (UM)** : Broker de messages, pub/sub
- **Trading Networks (TN)** : B2B Gateway, EDI
- **API Gateway** : Gestion et securisation des APIs
- **MWS** : My webMethods Server (portail)
- **BPM** : Process Engine, workflows

#### "Comment ajouter un nouveau serveur au landscape ?"

```bash
# 1. Creer le node dans CCE
sagcc create landscape nodes \
    name="Production IS 2" \
    alias=prodIs2 \
    url=http://server:8092

# 2. Configurer les credentials
sagcc add security credentials \
    nodeAlias=prodIs2 \
    runtimeComponentId=SPM-CONNECTION \
    authenticationType=BASIC \
    username=Administrator \
    password=****

# 3. Verifier la connexion
sagcc get landscape nodes prodIs2 status
```

---

### DevOps & Infrastructure

#### "Pourquoi Terraform + Ansible plutot que juste l'un ou l'autre ?"

> **Terraform** est ideal pour le **provisioning infrastructure** (creer des ressources cloud), tandis qu'**Ansible** excelle dans la **configuration management** (installer et configurer des logiciels).
>
> Dans mon projet :
> - Terraform cree l'instance EC2 et les security groups
> - Ansible installe webMethods et configure les services
>
> C'est le pattern "Infrastructure as Code" recommande.

#### "Pourquoi Supervisor plutot que systemd dans Docker ?"

> Systemd necessite des **privileges eleves** dans les containers (--privileged, cgroups) ce qui pose des problemes de securite. Supervisor est un **init system leger** parfaitement adapte aux containers :
>
> - Pas de privileges speciaux requis
> - Gestion simple des processus
> - Redemarrage automatique en cas de crash
> - Logs centralises

#### "Comment garantir l'idempotence de vos playbooks Ansible ?"

> J'utilise plusieurs techniques :
>
> 1. **Flag files** : Je cree un fichier `.installer_run` apres l'installation
> 2. **Condition `when`** : Verifie si l'action est necessaire
> 3. **Parametre `creates`** : Le shell ne s'execute que si le fichier n'existe pas
>
> Ainsi, le playbook peut etre execute plusieurs fois sans effet de bord.

---

## Votre projet - Points cles a mentionner

### Architecture

```
Terraform (AWS)
    └── EC2 + Security Groups
            └── Ansible (Configuration)
                    └── webMethods CC + SPM
                            └── Supervisor (Services)
```

### Metriques impressionnantes

| Metrique | Valeur |
|----------|--------|
| Lignes de code Ansible | 624 |
| Dockerfiles | 6 variantes |
| Modules Terraform | 7 |
| Commits | 21 |
| Temps de deploiement | ~15 min (cloud) |

### Differenciateurs

1. **Multi-environnement** : Local (Docker/Vagrant) ET Cloud (AWS)
2. **Automatisation complete** : Zero intervention manuelle
3. **Multi-plateforme** : Ubuntu, Oracle Linux, RHEL (WIP)
4. **Documentation** : Code documente + guides

---

## Questions a poser au recruteur

1. "Quelle version de webMethods utilisez-vous actuellement ?"
2. "Comment gerez-vous les deploiements ? CI/CD ou manuel ?"
3. "Travaillez-vous avec Command Central ou installation manuelle ?"
4. "Quels produits sont deployes ? IS, UM, TN ?"
5. "Y a-t-il des projets de migration vers le cloud ?"

---

## Termes techniques a connaitre

| Terme | Definition |
|-------|------------|
| **Landscape** | Ensemble des nodes manages par CCE |
| **Node** | Serveur avec SPM installe |
| **Environment** | Regroupement logique de nodes (DEV, PROD) |
| **Template** | Definition d'installation reproductible |
| **Fix** | Patch/correctif Software AG |
| **Repository** | Source de produits ou fixes |
| **Profile** | Configuration d'un produit (CCE, SPM, IS) |
| **Runtime** | Instance en cours d'execution |

---

## Commandes sagcc essentielles

```bash
# Lister les nodes
sagcc list landscape nodes

# Status d'un node
sagcc get landscape nodes <alias> status

# Lister les produits installes
sagcc list inventory products nodeAlias=<alias>

# Demarrer un runtime
sagcc exec lifecycle runtimes <node> <runtime> start

# Importer une licence
sagcc add license-tools keys -i licence.zip
```

---

## Scenarios d'entretien pratique

### "Deployez un Integration Server"

```bash
# 1. S'assurer que le repo est configure
sagcc list repository products

# 2. Appliquer le template IS
sagcc exec provisioning composite apply \
    nodeAlias=myNode \
    template=is-layer \
    repo.product=wM10.15-products

# 3. Verifier l'installation
sagcc list inventory products nodeAlias=myNode

# 4. Demarrer IS
sagcc exec lifecycle runtimes myNode OSGI-IS_default start
```

### "Diagnostiquer un probleme de connexion SPM"

```bash
# 1. Verifier que SPM ecoute
netstat -tlnp | grep 8092

# 2. Tester localement
curl http://localhost:8092/spm/health

# 3. Verifier le firewall
iptables -L -n | grep 8092

# 4. Checker les logs
tail -f /opt/SAGCommandCentral/profiles/SPM/logs/wrapper.log
```

---

## Points forts a mettre en avant

1. **Autonomie** : "J'ai appris webMethods CC en autodidacte via ce projet"
2. **Approche DevOps** : "Infrastructure as Code, automatisation complete"
3. **Polyvalence** : "Docker, Terraform, Ansible, Shell, AWS"
4. **Documentation** : "Je documente mon travail (ce site MkDocs)"
5. **Problem-solving** : "J'ai resolu des problemes complexes (Supervisor vs systemd)"

---

## Lien vers le projet

**Repository** : `https://github.com/nkaurelien/webmethods-devops-portfolio`

**Documentation** : `https://nkaurelien.github.io/webmethods-devops-portfolio`

> *"Je vous invite a consulter mon projet sur GitHub. Vous y trouverez le code source complet et cette documentation detaillee."*
