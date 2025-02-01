#!/bin/bash

# Set default values
CC_INSTALLER_PATH="../installer/cc-def-10.15-fix8-lnxamd64.sh"
CC_ADMIN_PASSWORD="manage123"
CC_ADMIN_HOST="sagbase.local"

# Function to add entry to /etc/hosts if CC_ADMIN_HOST ends with .local
add_host_entry() {
    if [[ "$CC_ADMIN_HOST" == *.local ]]; then
        echo "" >> /etc/hosts
        echo "# Custom entries for Command Central" >> /etc/hosts
        echo "127.0.0.1    $CC_ADMIN_HOST" >> /etc/hosts
    fi
}

# Create a custom user with UID 1234 and GID 1234
create_user() {
    groupadd -g 1234 sagwm
    useradd -m -u 1234 -g sagwm wmuser
}

# Create directories and set permissions
create_directories() {
    mkdir -p /opt/SAGCommandCentral
    mkdir -p /opt/SAGCommandCentral/installer
    chown -R 1234:1234 /opt/SAGCommandCentral
    mkdir -p /home/wmuser/logs
}

# Copy and run the installer script
run_installer() {
    cp $CC_INSTALLER_PATH /home/wmuser/installer/installer.sh
    chmod +x /home/wmuser/installer/installer.sh
    su - wmuser -c "/home/wmuser/installer/installer.sh -d /opt/SAGCommandCentral -H $CC_ADMIN_HOST -c 8090 -C 8091 -s 8092 -S 8093 -p $CC_ADMIN_PASSWORD --accept-license"
    rm -rf /home/wmuser/installer
}

# Start the Command Central Server
start_command_central() {
    su - wmuser -c "nohup /opt/SAGCommandCentral/profiles/CCE/bin/startup.sh > /home/wmuser/logs/commandcentral.log 2>&1 &"
}

# Start the Platform Manager
start_platform_manager() {
    su - wmuser -c "nohup /opt/SAGCommandCentral/profiles/SPM/bin/startup.sh > /home/wmuser/logs/platformmanager.log 2>&1 &"
}

# Main script execution
main() {
    add_host_entry
    create_user
    create_directories
    run_installer
    start_command_central
    start_platform_manager
    echo "Services started. Check logs in /home/wmuser/logs for details."
}

# Run the main function
main
