# Vagrant - Developpement local

## Vue d'ensemble

**Vagrant** permet de creer des environnements de developpement locaux reproductibles. Ce projet l'utilise pour tester les playbooks Ansible et l'installation webMethods.

```mermaid
graph LR
    VG[Vagrantfile] --> VB[VirtualBox]
    VB --> VM[Ubuntu VM]
    VM --> ANS[Ansible Provisioner]
    ANS --> WM[webMethods CC/SPM]
```

---

## Configuration

### Vagrantfile principal

```ruby
# Vagrantfile

Vagrant.configure("2") do |config|
  # Image de base
  config.vm.box = "ubuntu/jammy64"

  # Configuration VirtualBox
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "4096"    # 4 GB RAM
    vb.cpus = 2           # 2 CPUs
  end

  # Redirection de ports
  config.vm.network "forwarded_port", guest: 8090, host: 8090  # CCE HTTP
  config.vm.network "forwarded_port", guest: 8091, host: 8091  # CCE HTTPS
  config.vm.network "forwarded_port", guest: 8092, host: 8092  # SPM HTTP
  config.vm.network "forwarded_port", guest: 8093, host: 8093  # SPM HTTPS

  # Dossier partage pour l'installateur
  config.vm.synced_folder "./installer", "/installer"

  # Configuration SSH
  config.ssh.username = "wmuser"

  # Provisioning Ansible
  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "ansible/playbook-with-supervisor.yml"
  end
end
```

---

## Prerequis

- **VirtualBox** 6.x ou 7.x
- **Vagrant** 2.3+
- **Ansible** installe sur la machine hote
- **Installateur** webMethods dans `./installer/`

---

## Utilisation

### Demarrage

```bash
# Creer et demarrer la VM
vagrant up

# Premiere execution = download box + provisioning
# Peut prendre 10-15 minutes
```

### Acces

```bash
# SSH dans la VM
vagrant ssh

# En tant que wmuser
sudo su - wmuser

# Acces web
# http://localhost:8090/cce/web
```

### Gestion

```bash
# Arreter la VM
vagrant halt

# Redemarrer
vagrant reload

# Relancer le provisioning
vagrant provision

# Supprimer la VM
vagrant destroy
```

### Status

```bash
# Etat de la VM
vagrant status

# Informations SSH
vagrant ssh-config
```

---

## Structure de la VM

```
/home/wmuser/                    # Home utilisateur
/installer/                      # Dossier partage (host)
  └── cc-def-10.15-fix8-lnxamd64.sh

/opt/SAGCommandCentral/          # Installation webMethods
  ├── profiles/
  │   ├── CCE/
  │   └── SPM/
  └── CommandCentral/
      └── client/
          └── bin/sagcc
```

---

## Ports exposes

| Port VM | Port Host | Service |
|---------|-----------|---------|
| 8090 | 8090 | CCE HTTP |
| 8091 | 8091 | CCE HTTPS |
| 8092 | 8092 | SPM HTTP |
| 8093 | 8093 | SPM HTTPS |

---

## Provisioning Ansible

Le Vagrantfile execute automatiquement le playbook Ansible :

```ruby
config.vm.provision "ansible" do |ansible|
  ansible.playbook = "ansible/playbook-with-supervisor.yml"

  # Variables supplementaires (optionnel)
  ansible.extra_vars = {
    cc_admin_password: "manage123"
  }

  # Mode verbose
  ansible.verbose = "v"
end
```

---

## Variante alternative

```ruby
# Vagrantfile.hashicorpbionic64.exemple

Vagrant.configure("2") do |config|
  config.vm.box = "hashicorp/bionic64"  # Ubuntu 18.04

  # Meme configuration...
end
```

---

## Troubleshooting

### VM ne demarre pas

```bash
# Verifier VirtualBox
VBoxManage list vms

# Logs Vagrant
vagrant up --debug
```

### Provisioning echoue

```bash
# Relancer le provisioning
vagrant provision

# Mode verbose
ANSIBLE_VERBOSE=1 vagrant provision
```

### Probleme de synced folder

```bash
# Installer le plugin vbguest
vagrant plugin install vagrant-vbguest

# Recharger
vagrant reload
```

### Port deja utilise

```bash
# Verifier les ports
lsof -i :8090

# Modifier le port host dans Vagrantfile
config.vm.network "forwarded_port", guest: 8090, host: 18090
```

---

## Comparaison avec Docker

| Aspect | Vagrant | Docker |
|--------|---------|--------|
| **Isolation** | VM complete | Container leger |
| **Performance** | Plus lent | Plus rapide |
| **Ressources** | 4 GB RAM | ~500 MB |
| **Systemd** | Supporte | Non supporte |
| **Prod-like** | Tres proche | Adapte |
| **Demarrage** | Minutes | Secondes |

**Utiliser Vagrant quand :**

- Test d'installation complete
- Debug avec systemd
- Environnement proche production

**Utiliser Docker quand :**

- Developpement rapide
- CI/CD
- Ressources limitees
