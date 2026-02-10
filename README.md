# webMethods DevOps Portfolio

[![Deploy MkDocs](https://github.com/nkaurelien/webmethods-devops-portfolio/actions/workflows/docs.yml/badge.svg)](https://github.com/nkaurelien/webmethods-devops-portfolio/actions/workflows/docs.yml)

> **Automated deployment infrastructure for Software AG webMethods Command Central**

This project demonstrates end-to-end automation for deploying webMethods Command Central (CCE) and Platform Manager (SPM) using modern DevOps practices.

## Features

- **Infrastructure as Code**: Terraform for AWS provisioning
- **Configuration Management**: Ansible playbooks for automated installation
- **Containerization**: Docker with Supervisor for local development
- **Multi-environment**: Local (Vagrant/Docker) and Cloud (AWS)
- **Full automation**: Zero manual intervention deployment

## Tech Stack

| Category | Technologies |
|----------|-------------|
| **Platform** | webMethods 10.15, Command Central, SPM |
| **IaC** | Terraform 1.2+, Ansible |
| **Containers** | Docker, Docker Compose, Supervisor |
| **Cloud** | AWS (EC2, Security Groups) |
| **Local Dev** | Vagrant, VirtualBox |
| **Database** | SQL Server 2017 |
| **Auth** | Keycloak 26.1 |

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Deployment Options                        │
├─────────────────┬─────────────────┬─────────────────────────┤
│   Docker        │   Vagrant       │   AWS (Terraform)       │
│   Compose       │   + Ansible     │   + Ansible             │
├─────────────────┴─────────────────┴─────────────────────────┤
│                    webMethods Platform                       │
│  ┌─────────────────┐    ┌─────────────────┐                 │
│  │ Command Central │    │ Platform Manager │                │
│  │   (CCE)         │◄──►│   (SPM)          │                │
│  │   :8090/:8091   │    │   :8092/:8093    │                │
│  └─────────────────┘    └─────────────────┘                 │
├─────────────────────────────────────────────────────────────┤
│                    Supporting Services                       │
│  ┌─────────────────┐    ┌─────────────────┐                 │
│  │   SQL Server    │    │    Keycloak     │                 │
│  │     :1433       │    │     :8585       │                 │
│  └─────────────────┘    └─────────────────┘                 │
└─────────────────────────────────────────────────────────────┘
```

## Quick Start

### Option 1: Docker (Fastest)

```bash
# Start all services
docker compose up -d

# Check status
docker compose exec sagwm-cc supervisorctl status

# Access Command Central
open http://localhost:8090/cce/web
# Login: Administrator / manage123
```

### Option 2: Vagrant (Full VM)

```bash
# Start VM with provisioning
vagrant up

# SSH into the VM
vagrant ssh

# Access Command Central
open http://localhost:8090/cce/web
```

### Option 3: AWS (Production-like)

```bash
cd terraform

# Initialize and deploy
terraform init
terraform apply

# Get the public URL
terraform output command_central_url
```

## Project Structure

```
.
├── ansible/                    # Ansible playbooks
│   ├── playbook.yml
│   ├── playbook-with-supervisor.yml
│   └── playbook-with-supervisor-online.yml
├── docker/                     # Dockerfiles
│   ├── Dockerfile.supervisor
│   ├── Dockerfile.supervisor.oraclelinux
│   └── Dockerfile.wmSpm.supervisor
├── terraform/                  # AWS Infrastructure
│   ├── main.tf
│   ├── variables.tf
│   ├── security.tf
│   └── ansible.tf
├── scripts/                    # Provisioning scripts
├── docs/                       # MkDocs documentation
├── compose.yml                 # Docker Compose
└── Vagrantfile                 # Vagrant configuration
```

## Documentation

Full documentation available at: **https://nkaurelien.github.io/webmethods-devops-portfolio**

- [Architecture Overview](https://nkaurelien.github.io/webmethods-devops-portfolio/architecture/overview/)
- [Command Central Guide](https://nkaurelien.github.io/webmethods-devops-portfolio/webmethods/command-central/)
- [Terraform Setup](https://nkaurelien.github.io/webmethods-devops-portfolio/devops/terraform/)
- [Ansible Playbooks](https://nkaurelien.github.io/webmethods-devops-portfolio/devops/ansible/)

## CLI Reference

```bash
# List landscape nodes
sagcc list landscape nodes

# Check node status
sagcc get landscape nodes <alias> status

# Import licenses
sagcc add license-tools keys -i license.zip

# Start a runtime
sagcc exec lifecycle runtimes <node> <runtime> start
```

## Requirements

- Docker & Docker Compose (for container deployment)
- Vagrant & VirtualBox (for VM deployment)
- Terraform 1.2+ & AWS CLI (for cloud deployment)
- webMethods installer: `cc-def-10.15-fix8-lnxamd64.sh`

## Author

**Aurelien NK** - Software Engineer & DevOps

This project was built as a learning portfolio to demonstrate webMethods and DevOps expertise.

## License

This project is for educational and demonstration purposes.
