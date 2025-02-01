ENV['VAGRANT_DEFAULT_PROVIDER'] = 'virtualbox'

Vagrant.configure("2") do |config|
    # Use the Ubuntu box
    config.vm.box = "ubuntu/bionic64"  # Consider using a more recent version

    # Set ssh username
    VAGRANT_COMMAND = ARGV[0]
    if VAGRANT_COMMAND == "ssh"
      config.ssh.username = 'wmuser'
    end

    # Set the VM name
    config.vm.define "wmuser_vm"

    # Set up a private network
    config.vm.network "private_network", type: "dhcp"

    # Configure hardware resources
    config.vm.provider "virtualbox" do |vb|
        vb.memory = "4096"  # 4 GB of RAM
        vb.cpus = 2         # 2 CPUs
        # vb.customize ["modifyvm", :id, "--virtmode", "hostonly"]
        # vb.customize ["modifyvm", :id, "--disk", "20GB"]
    end

    # Port forwarding for exposed ports
    config.vm.network "forwarded_port", guest: 8090, host: 8090
    config.vm.network "forwarded_port", guest: 8091, host: 8091
    config.vm.network "forwarded_port", guest: 8092, host: 8092
    config.vm.network "forwarded_port", guest: 8093, host: 8093
    # Uncomment the following lines if needed
    # config.vm.network "forwarded_port", guest: 8094, host: 8094
    # config.vm.network "forwarded_port", guest: 8095, host: 8095

    # Reboot after provisioning is complete
    config.trigger.after [:provision] do |t|
      t.name = "Reboot after provisioning"
      t.run = { :inline => "vagrant reload" }
    end

    # Provision the VM with a shell script
    config.vm.provision "shell", inline: <<-SHELL
      # Update the package list
      sudo apt-get update

      # Create a custom user with UID 1234 and GID 1234
      sudo groupadd -g 1234 sagwm
      sudo useradd -m -u 1234 -g sagwm wmuser

      # Set the default shell to bash
      sudo chsh -s /bin/bash wmuser

      # Set the password for the user
      echo "wmuser:yourpassword" | sudo chpasswd

      # Create a directory for the installer
      sudo -u wmuser mkdir -p /home/wmuser/installer
      sudo -u wmuser chmod a+rwx /home/wmuser/installer

      # Copy SSH keys and set permissions
      if [ -d "/home/vagrant/.ssh" ] ; then
        cp -pr /home/vagrant/.ssh /home/wmuser/
        chown -R 1234:1234 /home/wmuser
      fi

      echo "%wmuser ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/wmuser

    SHELL

    # Use the file provisioner to upload the installer.sh script
    config.vm.provision "file", source: "./docker/installer/cc-def-10.15-fix8-lnxamd64.sh", destination: "/home/wmuser/installer/installer.sh"

    # Provision the VM with a shell script
    config.vm.provision "shell", inline: <<-SHELL
      # Create necessary directories
      sudo mkdir -p /opt/SAGCommandCentral
      sudo mkdir -p /opt/SAGCommandCentral/installer
      sudo chown -R 1234:1234 /opt/SAGCommandCentral

      # Set permissions for the installer script
      sudo chown wmuser:sagwm /home/wmuser/installer/installer.sh
      sudo chmod +x /home/wmuser/installer/installer.sh

      sudo -u wmuser touch /home/wmuser/.profile
      sudo -u wmuser touch /home/wmuser/.bashrc

      # Run the installer script (adjust the command as needed)
      sudo -u wmuser /home/wmuser/installer/installer.sh -d /opt/SAGCommandCentral -H localhost -c 8090 -C 8091 -s 8092 -S 8093 -p manage123 --accept-license

      if [ -f "/home/wmuser/.sag/profile" ] ; then
        sudo -u wmuser echo "" >> /home/wmuser/.profile
        sudo -u wmuser echo "# SAG Environment" >> /home/wmuser/.profile
        sudo -u wmuser cat /home/wmuser/.sag/profile >> /home/wmuser/.profile
      fi

      # Remove the installer script
      # sudo rm -rf /home/wmuser/installer/installer.sh
    SHELL
end
