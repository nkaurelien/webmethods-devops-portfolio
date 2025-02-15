#!/bin/bash
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

# Function to update the package list
update_package_list() {
  sudo apt-get update
}

# Function to create a custom user with UID and GID
create_user() {
  sudo groupadd -g $GROUP_GID $GROUPNAME
  sudo useradd -m -u $USER_UID -g $GROUPNAME $USERNAME
  sudo chsh -s /bin/bash $USERNAME
  echo "$USERNAME:$PASSWORD" | sudo chpasswd
}

# Function to copy SSH keys and set permissions
copy_ssh_keys() {
  if [ -d "/home/vagrant/.ssh" ]; then
    cp -pr /home/vagrant/.ssh /home/$USERNAME/
    chown -R $USER_UID:$GROUP_GID /home/$USERNAME
  fi
}

# Function to allow the user to run sudo commands without a password
allow_sudo_without_password() {
  echo "%$USERNAME ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USERNAME
}

# Function to create necessary directories
create_directories() {
  sudo mkdir -p $SAG_HOME
  sudo mkdir -p $SAG_HOME/installer
  sudo chown -R $USER_UID:$GROUP_GID $SAG_HOME
}

# Function to set permissions for the installer script
set_installer_permissions() {
  sudo chown $USERNAME:$GROUPNAME $INSTALLER_PATH
  sudo chmod +x $INSTALLER_PATH
}

# Function to create profile files for the user
create_profile_files() {
  sudo -u $USERNAME touch /home/$USERNAME/.profile
  sudo -u $USERNAME touch /home/$USERNAME/.bashrc
}

# Function to run the installer script
run_installer() {
  sudo -u $USERNAME $INSTALLER_PATH -d $SAG_HOME -H localhost -c 8090 -C 8091 -s 8092 -S 8093 -p $CC_ADMIN_PASSWORD --accept-license
}

# Function to append SAG environment variables to the user's profile
append_sag_environment() {
  if [ -f "/home/$USERNAME/.sag/profile" ]; then
    sudo -u $USERNAME echo "" >> /home/$USERNAME/.profile
    sudo -u $USERNAME echo "# SAG Environment" >> /home/$USERNAME/.profile
    sudo -u $USERNAME cat /home/$USERNAME/.sag/profile >> /home/$USERNAME/.profile
  fi
}

# Function to create a script to start commandcentral
create_start_script() {
  sudo -u $USERNAME cat <<EOF > /home/$USERNAME/start-commandcentral.sh
#!/bin/bash
mkdir -p /home/$USERNAME/logs && chown -R $USER_UID:$GROUP_GID /home/$USERNAME/logs
nohup $SAG_HOME/profiles/CCE/bin/startup.sh > /home/$USERNAME/logs/commandcentral.log 2>&1 &
nohup $SAG_HOME/profiles/SPM/bin/startup.sh > /home/$USERNAME/logs/platformmanager.log 2>&1 &
EOF
  chmod +x /home/$USERNAME/start-commandcentral.sh
  exec /home/$USERNAME/start-commandcentral.sh
}

# Main script execution
update_package_list
create_user
copy_ssh_keys
allow_sudo_without_password
create_directories
set_installer_permissions
create_profile_files
run_installer
append_sag_environment
create_start_script
