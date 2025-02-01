FROM centos:8

LABEL maintainer="Nkumbe Aurelien <nkaurelien@gmail.Com>"
LABEL fonction="Webmethods Developer and Integrator"
LABEL compagny="Wilow"
LABEL country="France"


ARG CC_INSTALLER_PATH
ARG CC_ADMIN_PASSWORD="manage123"
ARG CC_ADMIN_HOST="sagbase.local"
ARG CC_INSTALL_DIR="/opt/SAGCommandCentral"

# Set default environment variables
ENV CC_ADMIN_HOST=${CC_ADMIN_HOST}
ENV CC_ADMIN_PASSWORD=${CC_ADMIN_PASSWORD}
ENV CC_INSTALL_DIR=${CC_INSTALL_DIR}
ENV SHUTDOWN_TIMEOUT=30
ENV JVM_EXIT_TIMEOUT=15

# set installer label using basename form path
LABEL installer=$CC_INSTALLER_PATH

# Create a directory for the Command Central installation as ROOT
USER root

# Create a custom user with UID 1234 and GID 1234
RUN groupadd -g 1234 sagwm && \
    useradd -m -u 1234 -g sagwm wmuser

# Create directories and set permissions
RUN mkdir -p $CC_INSTALL_DIR && \
    chown -R 1234:1234 $CC_INSTALL_DIR && \
    mkdir -p /home/wmuser/logs 

# Switch to the custom user
USER wmuser


# Set the workdir
WORKDIR /home/wmuser

# create a directory for the installer
RUN mkdir -p /home/wmuser/installer

# Copy the script to the container
COPY --chmod=0777 $CC_INSTALLER_PATH /home/wmuser/installer/installer.sh

# Make the script executable
# RUN chmod +x /home/wmuser/installer/installer.sh

# Run the installer script
# RUN /home/wmuser/installer/installer.sh -d $CC_INSTALL_DIR -H $CC_ADMIN_HOST -c 8090 -C 8091 -s 8092 -S 8093 -p $CC_ADMIN_PASSWORD --accept-license
RUN /home/wmuser/installer/installer.sh -D CCE -d $CC_INSTALL_DIR -H $CC_ADMIN_HOST  -p $CC_ADMIN_PASSWORD --accept-license

# remove the installer
# RUN rm -rf /home/wmuser/installer

# Expose the Command Central ports
EXPOSE 8090 8091 8092 8093 8094 8095

USER root
# Create an entrypoint script to keep the container running
RUN cat <<EOF > /usr/local/bin/entrypoint.sh
#!/bin/bash

# Modify /etc/hosts if CC_ADMIN_HOST ends with .local
if [[ "$CC_ADMIN_HOST" == *.local ]]; then
    echo "" >> /etc/hosts
    echo "# Custom entries for Command Central" >> /etc/hosts
    echo "127.0.0.1    $CC_ADMIN_HOST" >> /etc/hosts
fi

# Start the Command Central services
/opt/SAGCommandCentral/common/bin/wrapper-3.5.53 /opt/SAGCommandCentral/profiles/CCE/configuration/wrapper.conf &
# /opt/SAGCommandCentral/common/bin/wrapper-3.5.53 /opt/SAGCommandCentral/profiles/SPM/configuration/wrapper.conf &

# Wait for any process to exit
wait -n

# Exit with status of process that exited first
exit $?
EOF

RUN chmod +x /usr/local/bin/entrypoint.sh

# Set the entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Switch back to the custom user
USER wmuser

# Start the Command Central services
CMD ["/opt/SAGCommandCentral/common/bin/wrapper-3.5.53", "/opt/SAGCommandCentral/profiles/CCE/configuration/wrapper.conf"]