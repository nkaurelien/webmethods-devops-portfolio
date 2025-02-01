# Install Webmethods CC


### Install command

```console
# SPM ports : 8792 (http), 8793 (https) , CCE use default ports

.\cc-def-10.15-fix8-w64.bat -d C:\SAGCommandCentral\cc1015 -H sagbase.wilow.local -c 8890 -C 8891 -s 8892 -S 8893 -p manage123 --accept-license

```

To list all exemple run

.\cc-def-10.2-release-w64.bat -h

### After Install
You can logon to Command Central Web UI as Administrator/manage123

https://sagbase.wilow.local:8891/cce/web
    

NOTE: for external clients you may need to use external hostname or IP instead of sagbase.wilow.local

You can also explore Command Central CLI command by running from a NEW shell window:

    sagcc --help


To use Command Central environment variables in future command prompt sessions execute:
   setx CC_CLI_HOME C:\SAGCommandCentral\cc102\CommandCentral\client
   setx PATH %CC_CLI_HOME%\bin

OR Add C:\SAGCommandCentral\cc102\CommandCentral\client\bin to environment system variable id the sagcc is not reconized


# Install Webmethods SPM in new Node


```console
.\cc-def-10.15-fix8-w64.bat -D SPM -d C:\SoftwareAG\spm1015 -H sagbase.wilow.local -s 8292 -S 8293 -p manage456 --accept-license

```

### After install

Installation of SPM completed

You can register this SPM node from your CCE or CLI installation:

```console
sagcc add landscape nodes url=http://sagbase.wilow.local:8292 alias=wMDev1
sagcc add security credentials nodeAlias=wMDev1 runtimeComponentId=SPM-CONNECTION username=Administrator password=manage456

sagcc add landscape environments alias=wMDevelpement description="my wM Dev installations"
sagcc add landscape environments wMDevelpement nodes nodeAlias=wMDev1

```

# Help

https://docs.webmethods.io/on-premises/webmethods-command-central/en/10.3.0/webhelp/index.html#page/cce-webhelp/cce.install.cc.html

### CC Docs
https://docs.webmethods.io/search?q=commande%20central

### CC Docs
https://docs.webmethods.io/search?q=commande%20central
https://docs.webmethods.io/on-premises/webmethods-command-central/en/10.7.0/admin-sag-prods-with-cc/index.html#page/cc-products-onlinehelp%2Fre-sample_templates.html%23