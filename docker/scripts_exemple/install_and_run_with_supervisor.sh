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

# Install supervisord
install_supervisord() {
    apt-get update
    apt-get install -y supervisor
}

# Create directories and set permissions
create_directories() {
    mkdir -p /opt/SAGCommandCentral
    mkdir -p /opt/SAGCommandCentral/installer
    chown -R 1234:1234 /opt/SAGCommandCentral
    mkdir -p /home/wmuser/logs/supervisor
}

# Copy and run the installer script
run_installer() {
    cp $CC_INSTALLER_PATH /home/wmuser/installer/installer.sh
    chmod +x /home/wmuser/installer/installer.sh
    su - wmuser -c "/home/wmuser/installer/installer.sh -d /opt/SAGCommandCentral -H $CC_ADMIN_HOST -c 8090 -C 8091 -s 8092 -S 8093 -p $CC_ADMIN_PASSWORD --accept-license"
    rm -rf /home/wmuser/installer
}

# Create the supervisord configuration file
create_supervisord_config() {
    mkdir -p /etc/supervisor/conf.d
    cat <<EOF > /etc/supervisor/conf.d/supervisord.conf
[supervisord]
nodaemon=true
logfile=/home/wmuser/logs/supervisor/supervisord.log
logfile_maxbytes=50MB
logfile_backups=10
loglevel=info

[inet_http_server]
port=127.0.0.1:9001

[program:commandcentral]
command=/opt/SAGCommandCentral/common/bin/wrapper-3.5.53 -s /opt/SAGCommandCentral/profiles/CCE/configuration/wrapper.conf
autostart=true
autorestart=true
user=wmuser
stdout_logfile=/home/wmuser/logs/supervisor/commandcentral.log
stderr_logfile=/home/wmuser/logs/supervisor/commandcentral_err.log

[program:platformmanager]
command=/opt/SAGCommandCentral/common/bin/wrapper-3.5.53 -s /opt/SAGCommandCentral/profiles/PM/configuration/wrapper.conf
autostart=true
autorestart=true
user=wmuser
stdout_logfile=/home/wmuser/logs/supervisor/platformmanager.log
stderr_logfile=/home/wmuser/logs/supervisor/platformmanager_err.log
EOF
}

# Start supervisord
start_supervisord() {
    /usr/bin/supervisord -n
}

# Main script execution
main() {
    add_host_entry
    create_user
    install_supervisord
    create_directories
    run_installer
    create_supervisord_config
    start_supervisord
}

# Run the main function
main
