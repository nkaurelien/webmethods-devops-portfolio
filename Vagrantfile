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
  (8090..8093).each do |port|
    config.vm.network "forwarded_port", guest: port, host: port
  end
  # Uncomment the following lines if needed
  # (8094..8095).each do |port|
  #   config.vm.network "forwarded_port", guest: port, host: port
  # end

  # Reboot after provisioning is complete
  config.trigger.after [:provision] do |t|
    t.name = "Reboot after provisioning"
    t.run = { :inline => "vagrant reload" }
  end

  # Sync the installer directory to the VM
  config.vm.synced_folder "./docker/installer", "/installer", disabled: false
  # config.vm.synced_folder ".", "/vagrant", disabled: false

  # Provision the VM with a shell script
  config.vm.provision "shell", inline: <<-SHELL
    set -ex  # Exit immediately if a command exits with a non-zero status and print each command before executing it

    # Variables
    USERNAME="wmuser"
    GROUPNAME="sagwm"
    USER_UID=1234
    GROUP_GID=1234
    PASSWORD="manage123"
    INSTALLER_PATH="/installer/cc-def-10.15-fix8-lnxamd64.sh"
    SAG_HOME="/opt/SAGCommandCentral"
    CC_ADMIN_PASSWORD="manage123"

    # Update the package list
    sudo apt-get update

    # Create a custom user with UID and GID
    sudo groupadd -g $GROUP_GID $GROUPNAME
    sudo useradd -m -u $USER_UID -g $GROUPNAME $USERNAME

    # Set the default shell to bash
    sudo chsh -s /bin/bash $USERNAME

    # Set the password for the user
    echo "$USERNAME:$PASSWORD" | sudo chpasswd

    # Copy SSH keys and set permissions
    if [ -d "/home/vagrant/.ssh" ]; then
      cp -pr /home/vagrant/.ssh /home/$USERNAME/
      chown -R $USER_UID:$GROUP_GID /home/$USERNAME
    fi

    # Allow the user to run sudo commands without a password
    echo "%$USERNAME ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USERNAME

    # Create necessary directories
    sudo mkdir -p $SAG_HOME
    sudo mkdir -p $SAG_HOME/installer
    sudo chown -R $USER_UID:$GROUP_GID $SAG_HOME

    # Set permissions for the installer script
    sudo chown $USERNAME:$GROUPNAME $INSTALLER_PATH
    sudo chmod +x $INSTALLER_PATH

    # Create profile files for the user
    sudo -u $USERNAME touch /home/$USERNAME/.profile
    sudo -u $USERNAME touch /home/$USERNAME/.bashrc

    # Run the installer script (adjust the command as needed)
    sudo -u $USERNAME $INSTALLER_PATH -d $SAG_HOME -H localhost -c 8090 -C 8091 -s 8092 -S 8093 -p $CC_ADMIN_PASSWORD --accept-license

    # Append SAG environment variables to the user's profile
    if [ -f "/home/$USERNAME/.sag/profile" ]; then
      sudo -u $USERNAME echo "" >> /home/$USERNAME/.profile
      sudo -u $USERNAME echo "# SAG Environment" >> /home/$USERNAME/.profile
      sudo -u $USERNAME cat /home/$USERNAME/.sag/profile >> /home/$USERNAME/.profile
    fi

    # Optionally remove the installer script
    # sudo rm -rf $INSTALLER_PATH

    # Create a script to start commandcentral
    sudo -u $USERNAME cat <<EOF > /home/$USERNAME/start-commandcentral.sh
#!/bin/bash
mkdir -p /home/$USERNAME/logs && chown -R $USER_UID:$GROUP_GID /home/$USERNAME/logs
nohup $SAG_HOME/profiles/CCE/bin/startup.sh > /home/$USERNAME/logs/commandcentral.log 2>&1 &
nohup $SAG_HOME/profiles/SPM/bin/startup.sh > /home/$USERNAME/logs/platformmanager.log 2>&1 &
EOF

    chmod +x /home/$USERNAME/start-commandcentral.sh
    exec /home/$USERNAME/start-commandcentral.sh
    
  SHELL

end
