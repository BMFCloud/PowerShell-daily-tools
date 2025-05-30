# UpgradeStopServices.ps1
# Safely shuts down all core services and switches the site into maintenance mode ahead of an upgrade.
# Intended for use during planned deployments, system patching, or infrastructure changes.

# Author: Brandon Fortunato
# Created: 03/08/2017




#First Take down the [Site Name] Site and set to Maintenance Mode

 

 Import-Module WebAdministration

 Stop-Website '[Site Name]'

 Start-Website '[Site Name] Server Maintenance'

 

    #Outputs to user site is in maintenance mode

    Write-Host "[Site Name] Maintenance Page active"



  

 #Stop Services, easiest to add force stop parameter to each service

 Stop-Service -Name Service1 -force

  Stop-Service -Name Service2 -force

    Stop-Service -Name Service3 -force

       Stop-Service -Name SQLSERVERAGENT -force

        

#Set all Services to Manual in preparation of a Reboot

 Set-Service -Name Service1 -StartupType Manual

 Set-Service -Name Service2 -StartupType Manual

 Set-Service -Name Service3 -StartupType Manual 

 Set-Service -Name SQLSERVERAGENT -StartupType Manual 

 

 

 

 



 

     Write-Host "All Services Stopped and Set to Manual"