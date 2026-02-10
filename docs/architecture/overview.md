# Vue d'ensemble de l'architecture

## Architecture globale

Ce projet implemente une architecture **multi-couche** permettant le deploiement de webMethods Command Central dans differents environnements.

```mermaid
graph TB
    subgraph User["Utilisateur"]
        DEV[Developpeur]
    end

    subgraph Local["Environnement Local"]
        VAGRANT[Vagrant<br/>VirtualBox]
        DOCKER[Docker<br/>Compose]
    end

    subgraph Cloud["AWS Cloud"]
        TF[Terraform]
        EC2[EC2 Instance<br/>Ubuntu 22.04]
        SG[Security Groups]
    end

    subgraph Config["Configuration"]
        ANS[Ansible<br/>Playbooks]
        SCRIPTS[Shell<br/>Scripts]
    end

    subgraph Platform["webMethods Platform"]
        CCE[Command Central<br/>:8090/:8091]
        SPM[Platform Manager<br/>:8092/:8093]
    end

    subgraph Services["Services Annexes"]
        SQL[(SQL Server<br/>:1433)]
        KC[Keycloak<br/>:8585]
    end

    DEV --> VAGRANT
    DEV --> DOCKER
    DEV --> TF

    TF --> EC2
    TF --> SG
    TF --> ANS

    VAGRANT --> ANS
    DOCKER --> SCRIPTS

    ANS --> CCE
    ANS --> SPM
    SCRIPTS --> CCE
    SCRIPTS --> SPM

    CCE --> SQL
    CCE --> KC
    SPM --> CCE
```

---

## Flux de deploiement

### Option 1 : Deploiement AWS (Production)

```mermaid
sequenceDiagram
    participant Dev as Developpeur
    participant TF as Terraform
    participant AWS as AWS
    participant ANS as Ansible
    participant WM as webMethods

    Dev->>TF: terraform apply
    TF->>AWS: Cree EC2 + Security Groups
    AWS-->>TF: Instance ID + DNS
    TF->>ANS: Execute playbook
    ANS->>AWS: SSH connexion
    ANS->>WM: Installation CC/SPM
    WM-->>Dev: Services disponibles
```

### Option 2 : Deploiement Local (Docker)

```mermaid
sequenceDiagram
    participant Dev as Developpeur
    participant DC as Docker Compose
    participant SUP as Supervisor
    participant WM as webMethods

    Dev->>DC: docker compose up
    DC->>DC: Build images
    DC->>SUP: Demarre containers
    SUP->>WM: Lance CCE + SPM
    WM-->>Dev: http://localhost:8090
```

### Option 3 : Deploiement Local (Vagrant)

```mermaid
sequenceDiagram
    participant Dev as Developpeur
    participant VG as Vagrant
    participant VM as VirtualBox
    participant ANS as Ansible
    participant WM as webMethods

    Dev->>VG: vagrant up
    VG->>VM: Cree VM Ubuntu
    VG->>ANS: Provision playbook
    ANS->>WM: Installation CC/SPM
    WM-->>Dev: http://localhost:8090
```

---

## Composants webMethods

### Command Central (CCE)

Le **coeur** de l'administration webMethods :

| Aspect | Detail |
|--------|--------|
| **Role** | Console d'administration centralisee |
| **Ports** | 8090 (HTTP), 8091 (HTTPS) |
| **Profil** | `/opt/SAGCommandCentral/profiles/CCE/` |
| **CLI** | `sagcc` |

### Platform Manager (SPM)

L'**agent** de deploiement sur chaque noeud :

| Aspect | Detail |
|--------|--------|
| **Role** | Gestion locale des produits SAG |
| **Ports** | 8092 (HTTP), 8093 (HTTPS) |
| **Profil** | `/opt/SAGCommandCentral/profiles/SPM/` |
| **Communication** | Vers CCE via REST API |

---

## Structure des repertoires

```
/opt/SAGCommandCentral/           # SAG_HOME
├── CommandCentral/
│   └── client/
│       └── bin/
│           └── sagcc             # CLI Command Central
├── profiles/
│   ├── CCE/                      # Profil Command Central
│   │   └── bin/
│   │       ├── startup.sh
│   │       └── shutdown.sh
│   └── SPM/                      # Profil Platform Manager
│       └── bin/
│           ├── startup.sh
│           └── shutdown.sh
├── common/                       # Librairies partagees
└── install/                      # Logs d'installation
```

---

## Ports et securite

### Matrice des ports

| Service | Port HTTP | Port HTTPS | Usage |
|---------|-----------|------------|-------|
| Command Central | 8090 | 8091 | Administration |
| Platform Manager | 8092 | 8093 | Agent local |
| Integration Server | 5555 | - | Services REST/SOAP |
| Universal Messaging | 9200 | - | Messaging |
| IS Diagnostic | 9999 | - | Debug |
| SQL Server | 1433 | - | Base de donnees |
| Keycloak | 8585 | - | Authentification |

### Security Groups AWS

```hcl
# Regles d'entree configurees
ingress {
  from_port   = 8090
  to_port     = 8094
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  description = "webMethods CC & SPM"
}

ingress {
  from_port   = 5555
  to_port     = 5555
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  description = "Integration Server"
}
```

---

## Gestion des processus

### Supervisor (Containers/VM)

```ini
[program:commandcentral]
command=/opt/SAGCommandCentral/profiles/CCE/bin/startup.sh
autostart=true
autorestart=true
stdout_logfile=/var/log/supervisor/cce.log

[program:platformmanager]
command=/opt/SAGCommandCentral/profiles/SPM/bin/startup.sh
autostart=true
autorestart=true
stdout_logfile=/var/log/supervisor/spm.log
```

**Avantages de Supervisor :**

- Redemarrage automatique en cas de crash
- Gestion unifiee des logs
- Compatible containers (pas besoin de systemd)
- Interface de controle (`supervisorctl`)

---

## Considerations de production

### Haute disponibilite

```mermaid
graph LR
    LB[Load Balancer] --> CCE1[CCE Node 1]
    LB --> CCE2[CCE Node 2]
    CCE1 --> DB[(SQL Server<br/>Cluster)]
    CCE2 --> DB
    CCE1 --> SPM1[SPM Node 1]
    CCE1 --> SPM2[SPM Node 2]
    CCE2 --> SPM1
    CCE2 --> SPM2
```

### Checklist production

- [ ] Activer HTTPS uniquement
- [ ] Configurer certificats SSL valides
- [ ] Restreindre les Security Groups
- [ ] Configurer la sauvegarde SQL Server
- [ ] Mettre en place le monitoring
- [ ] Configurer les alertes
