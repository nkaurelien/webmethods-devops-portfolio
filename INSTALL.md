# install Webmethods 

By: nkaurelien


### Create user wih sudo

```console

sudo su -

sudo useradd -m  wmuser
echo "wmuser:manage" | sudo chpasswd

```
Allow members of the sudo (or wheel) group to use sudo, ensure the following line is present in the /etc/sudoers file

wmuser   ALL=(ALL:ALL) ALL

```console
EDITOR=nano sudo visudo

```


### prepare script

```console
sudo -u wmuser -i bash
chmod +x cc-def-10.7-fix9-lnxamd64.sh 

```
### set super user password
export uperCCAdm1n=oracle

### Install command

./cc-def-10.7-fix9-lnxamd64.sh -D CCE -d /opt/sagcc/cc107 -p manage --accept-license 
./cc-def-10.7-fix9-lnxamd64.sh -D CCE -d $HOME/sagcc/cc107 -p manage --accept-license 


If you have a VM with a Hostname (edit etc/hosts if needed)

./cc-def-10.7-fix9-lnxamd64.sh -D CCE -d /opt/sagcc/cc107 -H cchost.com -c 9090 -C 9091 -s 9092 -S 9093 -p $uperCCAdm1n --accept-license

To list all exemple run

./cc-def-10.7-fix9-lnxamd64.sh

# Help

https://docs.webmethods.io/on-premises/webmethods-command-central/en/10.3.0/webhelp/index.html#page/cce-webhelp/cce.install.cc.html

### CC Docs
https://docs.webmethods.io/search?q=commande%20central

### CC Docs
https://docs.webmethods.io/search?q=commande%20central
https://docs.webmethods.io/on-premises/webmethods-command-central/en/10.7.0/admin-sag-prods-with-cc/index.html#page/cc-products-onlinehelp%2Fre-sample_templates.html%23

# Usefull Link 

###  install with Ant (Alternative)

https://github.com/SoftwareAG/sagdevops-cc-server?tab=readme-ov-file


```console
sudo dnf -y install ant-apache-bcel

```
