# Vagrantfile

Vagrant.configure("2") do |config|
    # Use the Ubuntu box
    # config.vm.box = "hashicorp/bionic64"
    config.vm.box = "ubuntu/trusty64"
  
    # Set the VM name
    config.vm.define "wmuser_vm"
  
    # Set up a private network
    config.vm.network "private_network", type: "dhcp"
  
    # Configure hardware resources
    config.vm.provider "virtualbox" do |vb|
        vb.memory = "4096"  # 4 GB of RAM
        vb.cpus = 2         # 2 CPUs
        vb.customize ["modifyvm", :id, "--virtmode", "hostonly"]
        vb.customize ["modifyvm", :id, "--memory", "4096"]
        vb.customize ["modifyvm", :id, "--cpus", "2"]
        vb.customize ["modifyvm", :id, "--disk", "20GB"]
    end

    # Port forwarding for exposed ports
    config.vm.network "forwarded_port", guest: 8090, host: 8090
    config.vm.network "forwarded_port", guest: 8091, host: 8091
    config.vm.network "forwarded_port", guest: 8092, host: 8092
    config.vm.network "forwarded_port", guest: 8093, host: 8093
    # config.vm.network "forwarded_port", guest: 8094, host: 8094
    # config.vm.network "forwarded_port", guest: 8095, host: 8095

    # Provision the VM with Ansible
    # config.vm.provision "ansible" do |ansible|
    #     ansible.playbook = "provisioning/playbook.yml"
    # end

    # Provision the VM with a shell script
    config.vm.provision "shell", inline: <<-SHELL
      # Update the package list
      sudo apt-get update
  
      # Create a custom user with UID 1234 and GID 1234
      sudo groupadd -g 1234 sagwm
      sudo useradd -m -u 1234 -g sagwm wmuser
  
      # Create necessary directories
      sudo mkdir -p /opt/SAGCommandCentral
      sudo mkdir -p /opt/SAGCommandCentral/installer
      sudo chown -R 1234:1234 /opt/SAGCommandCentral
  
      # Create a directory for the installer
      sudo -u wmuser mkdir -p /home/wmuser/installer
  
      # Set permissions for the installer script
      sudo chown wmuser:sagwm /home/wmuser/installer/installer.sh
      sudo chmod +x /home/wmuser/installer/installer.sh
  
      # Run the installer script (adjust the command as needed)
      sudo -u wmuser /home/wmuser/installer/installer.sh -d /opt/SAGCommandCentral -H localhost -c 8090 -C 8091 -s 8092 -S 8093 -p manage123 --accept-license
  
      # Remove the installer script
      # sudo rm -rf /home/wmuser/installer
  

    SHELL
  
    # Use the file provisioner to upload the installer.sh script
    config.vm.provision "file", source: "./docker/installer/cc-def-10.15-fix8-lnxamd64.sh", destination: "/home/wmuser/installer/installer.sh"
  end
  