# Install Webmethods CC


### Install command central (Run as Administrator)

```console
cd C:\SAGCommandCentral\resources

# This will install : CCE and SPM

.\cc-def-10.15-fix8-w64.bat -d C:\SAGCommandCentral\cc1015 -H sagbase.wilow.local -c 8190 -C 8191 -s 8192 -S 8193 -p manage123 --accept-license

```

To install on a Windows system and configure CLI to point to Command Central:

Exemple:
`cc-def-10.7-release-w64.bat -d C:\AdminTools\sagcc -D CLI -H cchost.com  -c 9100 -C 9101 -p manage123`

### After Install
You can logon to Command Central Web UI as Administrator/manage123

https://sagbase.wilow.local:8191/cce/web
    

NOTE: for external clients you may need to use external hostname or IP instead of sagbase.wilow.local

You can also explore Command Central CLI command by running from a NEW shell window:

    sagcc --help


To use Command Central environment variables in future command prompt sessions execute:
   setx CC_CLI_HOME C:\SAGCommandCentral\cc102\CommandCentral\client
   setx PATH %CC_CLI_HOME%\bin

OR Add C:\SAGCommandCentral\cc102\CommandCentral\client\bin to environment system variable id the sagcc is not reconized



### After install

Installation of SPM completed

You can register this SPM node from your CCE or CLI installation:


```console

cd C:\SAGCommandCentral\cc1015\CommandCentral\client\bin

# Add licence

.\sagcc add license-tools keys -i C:\SAGCommandCentral\cc1015\resources/licences.zip

# add repository product

.\sagcc add repository products image name=wM10.15-imageRepo-products -i C:\SAGCommandCentral\cc1015\resources\wM10_15.zip description="Webmethods Local images Repo for products"

# add free downloaded repository product
.\sagcc add repository products image name=wM10.15-free-imageRepo-products -i C:\SAGCommandCentral\cc1015\resources\webMFreeDownload1015Win64bit.zip description="Webmethods Local images Repo for products - free dowmloaded images"

# add repository fixes

.\sagcc add repository fixes image name=wM10.15-imageRepo-fixes -i C:\SAGCommandCentral\cc1015\resources/wM10_15_fixes.zip description="Webmethods Local images Repo for fixes"


# add repo mirror products

.\sagcc add repository products mirror name=wM10.15-imageRepo-products-mirror sourceRepos=wM10.15-imageRepo-products

.\sagcc add repository products mirror name=wM10.15-free-imageRepo-products-mirror sourceRepos=wM10.15-free-imageRepo-products

# add repo mirror fixes

.\sagcc add repository fixes mirror name=wM10.15-imageRepo-fixes-mirror sourceRepos=wM10.15-imageRepo-fixes productRepos=wM10.15-imageRepo-products

```


### Install new IS and UM node and environement with SPM


```console
cd C:\SAGCommandCentral\resources

.\cc-def-10.15-fix8-w64.bat -D SPM -d C:\IBM\webMethods\wM1015 -H sagbase.wilow.local -s 8092 -S 8093 -p manage123 --accept-license

 # Navigate to CC client installation directory

cd C:\SAGCommandCentral\cc1015\CommandCentral\client\bin

# Create node : IBM Platform Manager (SPM) installation 

.\sagcc create landscape nodes name="Integration Server 1" alias=wmIsServer1 url=http://sagbase.wilow.local:8092
.\sagcc create landscape nodes name="UM Server 1" alias=wmUmServer1 url=http://sagbase.wilow.local:9092

## Security Credentials Commands
.\sagcc add security credentials nodeAlias=wmIsServer1 runtimeComponentId=SPM-CONNECTION authenticationType=BASIC username=Administrator password=manage123
.\sagcc add security credentials nodeAlias=wmUmServer1 runtimeComponentId=SPM-CONNECTION authenticationType=BASIC username=Administrator password=manage123

# create environement

.\sagcc add landscape environments alias=PROD_ESB_10.15

# Attach a node (An Installation) to an environment 

.\sagcc add landscape environments PROD_ESB_10.15 nodes nodeAlias=wmIsServer1
.\sagcc add landscape environments PROD_ESB_10.15 nodes nodeAlias=wmUmServer1

```


if you need to delete later.

.\sagcc delete landscape nodes alias=wmIs1

See also

sagcc add security credentials sharedsecret [environmentAlias=alias] secret=text_string  [options]


# Provisionning (install product on node)


```console


# Install dbConfigurator 

.\sagcc exec provisioning products local wM10.15-imageRepo-products-mirror install artifacts=DatabaseComponentConfigurator,PIEcdc,MATcdc,WOKcdc,WMNcdc,MWScdc,WPEcdc,TNScdc 

# Updating dbConfigurator 

.\sagcc exec provisioning fixes local wM10.15-imageRepo-fixes-mirror install products=DatabaseComponentConfigurator,PIEcdc,MATcdc,WOKcdc,WMNcdc,MWScdc,WPEcdc,TNScdc



```

see also

sagcc exec provisioning fixes nodeAlias uninstall artifacts={fixName1,fixName2 | ALL} [options]

# Configure Database (SqlServer)

jdbc:wm:sqlserver://sagwm-sql-server:1433;databaseName=master -u sa -p manage123 -au sa -ap manage123 -n LOGGER1015

```console

cd C:\SAGCommandCentral\cc1015\common\db\bin
cd C:\IBM\webMethods\wM1015\common\db\bin


# Creates the database user and storage

## atebase Live
.\dbConfigurator.bat -a create -d sqlserver -c storage -v latest -l "jdbc:wm:sqlserver://localhost:1433;databaseName=master" -u SQLUser1015 -p manage123 -au sa -ap manage123 -n LOGGER1015 

## datebase Archive 
.\dbConfigurator.bat -a create -d sqlserver -c storage -v latest -l "jdbc:wm:sqlserver://localhost:1433;databaseName=master" -u SQLUser1015 -p manage123 -au sa -ap manage123 -n ARCHIVE1015 


# Creating Database Components 

## MWS 

.\dbConfigurator.bat -a create -pr MWS -v latest -d sqlserver -l "jdbc:wm:sqlserver://localhost:1433;databaseName=LOGGER1015;MaxPooledStatements=35" -u SQLUser1015 -p manage123 

## TN 

.\dbConfigurator.bat -a create -pr TN -v latest -d sqlserver -l "jdbc:wm:sqlserver://localhost:1433;databaseName=LOGGER1015;MaxPooledStatements=35" -u SQLUser1015 -p manage123 

## IS 

.\dbConfigurator.bat -a create -pr IS -v latest -d sqlserver -l "jdbc:wm:sqlserver://localhost:1433;databaseName=LOGGER1015;MaxPooledStatements=35" -u SQLUser1015 -p manage123 

# BPM 

.\dbConfigurator.bat -a create -pr PRE -v latest -d sqlserver -l "jdbc:wm:sqlserver://localhost:1433;databaseName=LOGGER1015;MaxPooledStatements=35" -u SQLUser1015 -p manage123 

## Archive 

.\dbConfigurator.bat -a create -c Archive -v latest -d sqlserver -l "jdbc:wm:sqlserver://localhost:1433;databaseName=ARCHIVE1015;MaxPooledStatements=35" -u SQLUser1015 -p manage123 
```

# Create IS Instance 

Command Central will now add this instance in your landscape.

- **Primary port:** 5555
- **Diagnostic port:** 9999
- **Secure port:** 5543
- **JMX port:** 8075
- **Database type:** SQL Server
- **JDBC URL:** `jdbc:wm:sqlserver://localhost:1433;databaseName=LOGGER1015;MaxPooledStatements=20;SelectMethod=cursor`
- **Database user:** SQLUser1015
- **Password:** manage123
- **Connection name:** ISInternal
- **Packages to add to this instance:** WmBusinessConsole, WmBusinessRules, WmCDS, WmCloudStreams, WmCommandCentral, WmConsole, WmDashboard, WmDesigner, WmDeveloper, WmIntegrationServer, WmMonitor, WmPackageManager, WmProcessManager, WmPublish, WmRepository, WmServerManager, WmTestClient, WmTopology, WmTransformationServer, WmTransport, WmWebReports
- **Instance name:** wm1015
- **License key file:** 0000834756_PIE_10.0_TEST_ANY
- **Register Windows service for automatic startup:** true
- **Password for Administrator user:** manage123
- **Change Administrator password on first login:** No