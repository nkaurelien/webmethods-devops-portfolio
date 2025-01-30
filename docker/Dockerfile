# Use the official Ubuntu image as the base
FROM ubuntu:20.04

LABEL maintainer="Nkumbe Aurelien <nkaurelien@gmail.Com>"
LABEL fonction="Webmethods Developer and Integrator"
LABEL compagny="Wilow"
LABEL country="France"

ARG CC_INSTALLER_PATH
ARG CC_ADMIN_PASSWORD="manage123"
ARG CC_ADMIN_HOST="localhost"

# set installer label using basename form path
# LABEL installer=`basename $CC_INSTALLER_PATH`
LABEL installer=$CC_INSTALLER_PATH

# Create a directory for the Command Central installation as ROOT
USER root

# Create a custom user with UID 1234 and GID 1234
RUN groupadd -g 1234 sagwm && \
    useradd -m -u 1234 -g sagwm wmuser

# Create a directory for the Command Central installation
RUN mkdir -p /opt/SAGCommandCentral
RUN mkdir -p /opt/SAGCommandCentral\installer

# set owner and group of the Command Central directory
RUN chown -R 1234:1234 /opt/SAGCommandCentral

 
# Switch to the custom user
USER wmuser
 
# Set the workdir
WORKDIR /home/wmuser

# create a directory for the installer
RUN mkdir -p /home/wmuser/installer

# Copy the script to the container
COPY $CC_INSTALLER_PATH /home/wmuser/installer/installer.sh

# Make the script executable
RUN /home/wmuser/installer/installer.sh -d /opt/SAGCommandCentral -H $CC_ADMIN_HOST -c 8090 -C 8091 -s 8092 -S 8093 -p $CC_ADMIN_PASSWORD --accept-license

# remove the installer
RUN rm -rf /home/wmuser/installer

# Expose the Command Central ports
EXPOSE 8090 8091 8092 8093 8094 8095

# create service unit file
RUN echo "[Unit]" > /etc/systemd/system/cc.service

# add entry to /etc/hosts if needed $CC_ADMIN_HOST != localhost

# Create deamon service
# RUN echo "wrapper.daemonize=TRUE" >> /opt/SAGCommandCentral/profiles/CCE/configuration/wrapper.conf

# Start the Command Central and SPM
CMD /opt/SAGCommandCentral/common/bin/wrapper-3.5.53 -s /opt/SAGCommandCentral/profiles/CCE/configuration/wrapper.conf

# Print the UID and GID
# RUN sh -c "echo 'Inside Container:' && echo 'User: $(whoami) UID: $(id -u) GID: $(id -g)' && ls -sal /opt/SAGCommandCentral"

# CMD sh -c "/opt/SAGCommandCentral/common/bin/wrapper-3.5.53 -s /opt/SAGCommandCentral/profiles/CCE/configuration/wrapper.conf"



