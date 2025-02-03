#!/bin/bash

# Set default values
CC_INSTALLER_PATH="../installer/cc-def-10.15-fix8-lnxamd64.sh"
CC_ADMIN_PASSWORD="manage123"
CC_ADMIN_HOST="sagbase.local"
CC_INSTALL_DIR="/opt/SAGCommandCentral"
WMUSER_HOME="/home/wmuser"
LOG_DIR="${WMUSER_HOME}/logs"
WMUSER_UID=1234
WMUSER_GID=1234
WMUSER_GROUP="sagwm"
WMUSER_NAME="wmuser"

# Function to add entry to /etc/hosts if CC_ADMIN_HOST ends with .local
add_host_entry() {
    if [[ "$CC_ADMIN_HOST" == *.local ]]; then
        echo "" >> /etc/hosts
        echo "# Custom entries for Command Central" >> /etc/hosts
        echo "127.0.0.1    $CC_ADMIN_HOST" >> /etc/hosts
    fi
}

# Create a custom user with specified UID and GID
create_user() {
    groupadd -g $WMUSER_GID $WMUSER_GROUP
    useradd -m -u $WMUSER_UID -g $WMUSER_GROUP $WMUSER_NAME
}

# Create directories and set permissions
create_directories() {
    mkdir -p $CC_INSTALL_DIR
    chown -R $WMUSER_UID:$WMUSER_GID $CC_INSTALL_DIR
    mkdir -p $LOG_DIR
    chown -R $WMUSER_UID:$WMUSER_GID $LOG_DIR
}

# Run the installer script
run_installer() {
    chmod +x $CC_INSTALLER_PATH
    su - $WMUSER_NAME -c "$CC_INSTALLER_PATH -d $CC_INSTALL_DIR -H $CC_ADMIN_HOST -c 8090 -C 8091 -s 8092 -S 8093 -p $CC_ADMIN_PASSWORD --accept-license"
}

# Main script execution
main() {
    add_host_entry
    create_user
    create_directories
    run_installer
    echo "Installation completed. You can start the services manually."
}

# Run the main function
main
