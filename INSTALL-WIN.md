# install Webmethods 

By: nkaurelien



### prepare script

```console
cd C:\Training\613-72E\cc-def-10.2-fix1-w64


```
### Install command

.\cc-def-10.2-release-w64.bat -d C:\SAGCommandCentral\cc101 -H sagbase.wilow.local -s 8792 -S 8793 -p manage123 --accept-license

.\cc-def-10.15-fix8-w64.bat -d C:\SAGCommandCentral\cc1015 -H sagbase.wilow.local -c 8890 -C 8891 -s 8892 -S 8893 -p manage123 --accept-license

If you have a VM with a Hostname (edit etc/hosts if needed)

.\cc-def-10.2-release-w64.bat  -D CCE -d C:\SAGCommandCentral\cc101 -H sagbase.wilow.local -s 8792 -S 8793 -p manage123 --accept-license

.\cc-def-10.2-release-w64.bat  -D CCE -d C:\SAGCommandCentral\cc101 -H sagbase.wilow.local -c 8790 -C 8791 -s 8792 -S 8793 -p manage123 --accept-license

To list all exemple run

.\cc-def-10.2-release-w64.bat 

## After Install
You can logon to Command Central Web UI as Administrator/manage123

    https://sagbase.wilow.local:8091/cce/web 
    https://sagbase.wilow.local:8891/cce/web
    

NOTE: for external clients you may need to use external hostname or IP instead of sagbase.wilow.local

You can also explore Command Central CLI command by running from a NEW shell window:

    sagcc --help


To use Command Central environment variables in future command prompt sessions execute:
   setx CC_CLI_HOME C:\SAGCommandCentral\cc101\CommandCentral\client
   setx PATH %CC_CLI_HOME%\bin

OR Add C:\SAGCommandCentral\cc101\CommandCentral\client\bin to environment system variable id the sagcc is not reconized

# Help

https://docs.webmethods.io/on-premises/webmethods-command-central/en/10.3.0/webhelp/index.html#page/cce-webhelp/cce.install.cc.html

### CC Docs
https://docs.webmethods.io/search?q=commande%20central

### CC Docs
https://docs.webmethods.io/search?q=commande%20central
https://docs.webmethods.io/on-premises/webmethods-command-central/en/10.7.0/admin-sag-prods-with-cc/index.html#page/cc-products-onlinehelp%2Fre-sample_templates.html%23

