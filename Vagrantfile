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
  end

  # Port forwarding for exposed ports
  (8090..8093).each do |port|
    config.vm.network "forwarded_port", guest: port, host: port
  end

  # Reboot after provisioning is complete
  config.trigger.after [:provision] do |t|
    t.name = "Reboot after provisioning"
    t.run = { :inline => "vagrant reload" }
  end

  # Sync the installer directory to the VM
  config.vm.synced_folder "./docker/installer", "/installer", disabled: false
  # config.vm.synced_folder ".", "/vagrant", disabled: false

  # Provision the VM with a shell script
  config.vm.provision "shell", path: "scripts/cc-provision.sh"
end
