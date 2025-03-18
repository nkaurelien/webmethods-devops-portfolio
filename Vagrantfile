ENV['VAGRANT_DEFAULT_PROVIDER'] = 'virtualbox'

Vagrant.configure("2") do |config|
  # Use the Ubuntu box
  config.vm.box = "ubuntu/jammy64"  # Consider using a more recent version

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

  # Sync the installer directory to the VM
  config.vm.synced_folder "./installer", "/installer", disabled: false

  # Provision the VM with a shell script
  # config.vm.provision "shell", path: "scripts/cc-provision.sh"

  # Provision the VM with Ansible
  config.vm.provision "ansible" do |ansible|
    # ansible.playbook = "ansible/playbook.yml"
    ansible.playbook = "ansible/playbook-with-supervisor.yml"

    # ansible.playbook = "ansible/playbook-with-supervisor-online.yml"
    # ansible.extra_vars = {
    #   cc_installer_path: "/installer/installer.sh",
    #   cc_installer_url: "http://192.168.0.29:9001/api/v1/download-shared-object/aHR0cDovLzEyNy4wLjAuMTo5MDAwL3dpbG93L2NjLWRlZi0xMC4xNS1maXg4LWxueGFtZDY0LnNoP1gtQW16LUFsZ29yaXRobT1BV1M0LUhNQUMtU0hBMjU2JlgtQW16LUNyZWRlbnRpYWw9VzhDTzNQQVJaVUM2UkVMUFQ0OTMlMkYyMDI1MDIxNSUyRnVzLWVhc3QtMSUyRnMzJTJGYXdzNF9yZXF1ZXN0JlgtQW16LURhdGU9MjAyNTAyMTVUMjI1NzQ5WiZYLUFtei1FeHBpcmVzPTQzMjAwJlgtQW16LVNlY3VyaXR5LVRva2VuPWV5SmhiR2NpT2lKSVV6VXhNaUlzSW5SNWNDSTZJa3BYVkNKOS5leUpoWTJObGMzTkxaWGtpT2lKWE9FTlBNMUJCVWxwVlF6WlNSVXhRVkRRNU15SXNJbVY0Y0NJNk1UY3pPVGN3TVRVeU5pd2ljR0Z5Wlc1MElqb2liV2x1YVc5aFpHMXBiaUo5LnJEaUpwVnRLdV9HbUxSbVZHTVJkTkpzQ2oyMWk4WTBJNGswS2dwR2pqUERSbmFycTBIcDVORW1SVlU1aXZndU9WVTVXVWZ1RWNQczQwM05xemVpYlFnJlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCZ2ZXJzaW9uSWQ9bnVsbCZYLUFtei1TaWduYXR1cmU9YTcyMTNjYTc4NWQ2MDQxZmM1YmEwMjgwMjcxNTU5ZjFlMjU3YzBiZDJmNTZhZDdkZGI5Y2RiMzFhZjA3NzRkZQ"
    # }
  end
end
