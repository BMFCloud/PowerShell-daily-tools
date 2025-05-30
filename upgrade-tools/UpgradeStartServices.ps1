# UpgradeStartServices.ps1
# Restores production environment services after a maintenance window or application upgrade.
# Starts core Windows services, re-enables the main website, and triggers application cache loading.
# Requires valid service names, SSL config, and IIS bindings to be pre-configured.

# Author: Brandon Fortunato
# Created: 03/08/2017


#First Start SQL Server Agent

 Set-Service -Name SQLSERVERAGENT -Status Running -StartupType Automatic

 

 

#Second Take down the [Site Name] Maintenance Site and bring up [Site Name] Site

 Import-Module WebAdministration

 Stop-Website '[Maintenance Site]'

 Start-Website '[Site Name]'

 

 #Full Reset of IIS after Site is enabled

 invoke-command -scriptblock {iisreset}

 

#Writes site is running

Write-Host "[Site Name] Site is Running"



#this is dynamic and will change with each customer you are rebooting, hits the front door to start cacheload

Invoke-WebRequest -URI "https://**.**.com"

 

 #Notifies user the cache has started to load

 Write-Host "Framework Tickled, Cache has started"

 

 

 #Brief Pause, Requires the user to visually confirm the portal caches are all loaded completely before running all [Site Name] services

 Write-Host "Access the portal and watch the Cache load."

 Write-Host "Once the final cache is loaded, select Yes [ Y ] to continue.."



  

 #Start Services and set Startup Type as Auto



 Set-Service -Name [Site Name]Service1 -Status Running -StartupType Automatic -confirm

 Set-Service -Name [Site Name]Service2 -Status Running -StartupType Automatic

 Set-Service -Name [Site Name]Service3 -Status Running -StartupType Automatic

 

 Write-Host "All Services Running"