# Diagrammes d'architecture

## Architecture de deploiement

### Vue globale multi-environnement

```mermaid
graph TB
    subgraph DEV["Environnement Developpement"]
        LAPTOP[Poste Developpeur]
        subgraph LOCAL["Local"]
            DOCKER[Docker Compose]
            VAGRANT[Vagrant VM]
        end
    end

    subgraph CLOUD["AWS Cloud"]
        subgraph VPC["VPC"]
            subgraph PUBLIC["Subnet Public"]
                EC2[EC2 Instance<br/>t2.medium]
            end
            SG[Security Group]
        end
    end

    subgraph CONFIG["Configuration Management"]
        TF[Terraform]
        ANS[Ansible]
    end

    LAPTOP --> DOCKER
    LAPTOP --> VAGRANT
    LAPTOP --> TF
    TF --> EC2
    TF --> SG
    TF --> ANS
    ANS --> EC2
    VAGRANT --> ANS
```

---

## Architecture webMethods

### Topologie Command Central

```mermaid
graph TB
    subgraph ADMIN["Administration"]
        BROWSER[Navigateur Web]
        CLI[sagcc CLI]
    end

    subgraph CCE["Command Central"]
        CCEWEB[CCE Web UI<br/>:8090/:8091]
        CCEAPI[CCE REST API]
        CCEJOBS[Job Engine]
    end

    subgraph NODES["Nodes Manages"]
        subgraph NODE1["Node 1"]
            SPM1[SPM<br/>:8092/:8093]
            IS1[Integration Server<br/>:5555]
        end
        subgraph NODE2["Node 2"]
            SPM2[SPM]
            UM2[Universal Messaging<br/>:9200]
        end
        subgraph NODE3["Node 3"]
            SPM3[SPM]
            TN3[Trading Networks]
        end
    end

    subgraph DATA["Data Layer"]
        DB[(SQL Server)]
        REPO[(Product Repository)]
        LIC[(License Server)]
    end

    BROWSER --> CCEWEB
    CLI --> CCEAPI
    CCEWEB --> CCEAPI
    CCEAPI --> CCEJOBS

    CCEJOBS --> SPM1
    CCEJOBS --> SPM2
    CCEJOBS --> SPM3

    SPM1 --> IS1
    SPM2 --> UM2
    SPM3 --> TN3

    CCEAPI --> DB
    CCEJOBS --> REPO
    CCEJOBS --> LIC
```

---

## Flux de provisioning

### Deploiement Terraform + Ansible

```mermaid
sequenceDiagram
    autonumber
    participant Dev as Developpeur
    participant TF as Terraform
    participant AWS as AWS API
    participant EC2 as EC2 Instance
    participant ANS as Ansible
    participant WM as webMethods

    Dev->>TF: terraform init
    Dev->>TF: terraform plan
    Dev->>TF: terraform apply

    TF->>AWS: Create Key Pair
    AWS-->>TF: Key ID

    TF->>AWS: Create Security Group
    AWS-->>TF: SG ID

    TF->>AWS: Launch EC2 Instance
    AWS-->>TF: Instance ID + Public DNS

    TF->>AWS: Execute User Data Script
    Note over EC2: apt-get update<br/>Install: htop, nginx, s3fs

    TF->>ANS: Create Inventory
    TF->>ANS: Execute Playbook

    ANS->>EC2: SSH Connection
    ANS->>EC2: Create user wmuser
    ANS->>EC2: Download Installer
    ANS->>EC2: Run Installation

    EC2->>WM: Install Command Central
    EC2->>WM: Install Platform Manager
    EC2->>WM: Configure Supervisor

    ANS->>EC2: Start Services
    EC2-->>Dev: Services Ready<br/>http://dns:8090
```

---

## Architecture Container

### Docker Compose Stack

```mermaid
graph TB
    subgraph COMPOSE["Docker Compose"]
        subgraph NETWORK["Bridge Network"]
            CC[sagwm-cc<br/>Ubuntu 22.04]
            SQL[sagwm-sql-server<br/>MSSQL 2017]
            KC[sagwm-keycloak<br/>Keycloak 26.1]
        end
    end

    subgraph CC_INTERNAL["Container: sagwm-cc"]
        SUP[Supervisor]
        CCE_PROC[CCE Process]
        SPM_PROC[SPM Process]
    end

    subgraph PORTS["Ports Exposes"]
        P8090[":8090 CCE HTTP"]
        P8091[":8091 CCE HTTPS"]
        P1433[":1433 SQL Server"]
        P8585[":8585 Keycloak"]
    end

    subgraph VOLUMES["Volumes"]
        V_SCRIPTS[./scripts]
        V_INSTALLER[./installer]
        V_SQL[sql-data]
    end

    CC --> P8090
    CC --> P8091
    SQL --> P1433
    KC --> P8585

    SUP --> CCE_PROC
    SUP --> SPM_PROC

    V_SCRIPTS --> CC
    V_INSTALLER --> CC
    V_SQL --> SQL

    CCE_PROC --> SQL
    CCE_PROC --> KC
```

---

## Cycle de vie des services

### Demarrage avec Supervisor

```mermaid
stateDiagram-v2
    [*] --> ContainerStart: docker run

    ContainerStart --> SupervisorInit: supervisord -n

    SupervisorInit --> CCEStarting: Start CCE
    SupervisorInit --> SPMStarting: Start SPM

    CCEStarting --> CCERunning: startup.sh success
    CCEStarting --> CCEFailed: startup.sh failed

    SPMStarting --> SPMRunning: startup.sh success
    SPMStarting --> SPMFailed: startup.sh failed

    CCEFailed --> CCEStarting: autorestart

    SPMFailed --> SPMStarting: autorestart

    CCERunning --> CCEStopped: shutdown.sh
    SPMRunning --> SPMStopped: shutdown.sh

    CCEStopped --> CCEStarting: supervisorctl start

    SPMStopped --> SPMStarting: supervisorctl start
```

---

## Modele de donnees

### Relations principales

```mermaid
erDiagram
    COMMAND_CENTRAL ||--o{ LANDSCAPE : manages
    LANDSCAPE ||--o{ ENVIRONMENT : contains
    ENVIRONMENT ||--o{ NODE : has
    NODE ||--|| SPM : runs
    SPM ||--o{ PRODUCT : manages
    PRODUCT ||--o{ INSTANCE : has

    COMMAND_CENTRAL {
        string id PK
        string hostname
        int http_port
        int https_port
    }

    LANDSCAPE {
        string id PK
        string name
        string description
    }

    ENVIRONMENT {
        string alias PK
        string name
        string type
    }

    NODE {
        string alias PK
        string hostname
        string url
    }

    SPM {
        string id PK
        int http_port
        int https_port
        string status
    }

    PRODUCT {
        string id PK
        string name
        string version
    }

    INSTANCE {
        string id PK
        string name
        string status
    }
```

---

## Integration CI/CD (Future)

### Pipeline propose

```mermaid
graph LR
    subgraph SOURCE["Source"]
        GIT[Git Repository]
    end

    subgraph BUILD["Build"]
        DOCKER_BUILD[Docker Build]
        TEST[Tests]
    end

    subgraph DEPLOY_DEV["Deploy Dev"]
        TF_DEV[Terraform Dev]
        ANS_DEV[Ansible Dev]
    end

    subgraph DEPLOY_PROD["Deploy Prod"]
        TF_PROD[Terraform Prod]
        ANS_PROD[Ansible Prod]
    end

    GIT --> DOCKER_BUILD
    DOCKER_BUILD --> TEST
    TEST --> TF_DEV
    TF_DEV --> ANS_DEV
    ANS_DEV --> TF_PROD
    TF_PROD --> ANS_PROD
```
