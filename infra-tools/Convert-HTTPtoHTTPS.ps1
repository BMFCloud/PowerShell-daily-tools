# Convert-HTTPtoHTTPS.ps1
# Purpose: Enforces HTTPS-only communication across an application's web, component, and SQL configuration layers.
# Overview:
# - Prompts the user to enter the application's FQDN.
# - Rewrites http:// references to https:// across key config files (web.config, component DLL config, SQL server config).
# - Applies direct SQL updates to convert legacy HTTP paths to HTTPS within relevant system tables.
# - Displays pre- and post-update values for validation.
#
# Requirements:
# - Valid SSL certificate installed in IIS.
# - Appropriate permissions to update files and execute SQL commands.
#
# Author: Brandon Fortunato
# Created: 05/15/2019

$dir = 'C:\Path\To\App\web.config'
$compconfig = 'C:\Path\To\App\Components\components.dll.config'
$sql = 'C:\Path\To\SQL\sqlservr.exe.config'

$emname = Read-Host "Please Enter FQDN (Ex: your-application.domain.com)"
$emname = $emname.ToLower()

Write-Host "`nYou Entered: $emname`n"

$confirmation = Read-Host "*** Are you sure this URL is correct? (y/n) ***"
while ($confirmation -ne "y") {
    if ($confirmation -eq "n") { exit }
    $confirmation = Read-Host "Please verify entry. [y/n]"
}

Import-Module IISAdministration

# Update web.config
(Get-Content $dir).Replace("http://$emname", "https://$emname") | Set-Content $dir
(Get-Content $dir).Replace("http://localhost/Framework/SoapEventService.asmx", "https://localhost/Framework/SoapEventService.asmx") | Set-Content $dir
(Get-Content $dir).Replace("https://$emname/Framework/Designer.asmx", "http://$emname/Framework/Designer.asmx") | Set-Content $dir
Write-Host "web.config updated.`n"

# Update SQL server config
(Get-Content $sql).Replace("http://127.0.0.1/Framework/ManagedModules.asmx", "https://$emname/Framework/ManagedModules.asmx") | Set-Content $sql
Write-Host "sqlservr.exe.config updated.`n"

# Update components config
(Get-Content $compconfig).Replace("http://$emname", "https://$emname") | Set-Content $compconfig
Write-Host "components.dll.config updated.`n"

Start-Sleep -Seconds 3

# Update database paths from http to https
$SqlCmd = New-Object System.Data.SqlClient.SqlCommand
$SqlCmd.Connection = New-Object System.Data.SqlClient.SqlConnection
$SqlCmd.Connection.ConnectionString = 'Server=LOCALHOST;Database=YourDatabase;Integrated Security=True'
$SqlCmd.Connection.Open()
$SqlCmd.CommandText = @"
UPDATE [YourDatabase].[schema].[YourTable]
SET [Column] = REPLACE([Column], 'http:', 'https:')
WHERE [Column] LIKE 'http:%'

-- Additional SQL updates to various system tables
UPDATE [YourDatabase].[schema].[Schedules]
SET [URLColumn] = REPLACE([URLColumn], 'http:', 'https:')
WHERE [URLColumn] LIKE 'http:%'

UPDATE [YourDatabase].[schema].[UtilTable]
SET CommandString = REPLACE(CommandString, 'http:', 'https:')
WHERE CommandString IS NOT NULL
"@
$SqlCmd.ExecuteNonQuery()
$SqlCmd.Connection.Close()

Write-Host "All configuration files and database references updated to HTTPS.`n"
Write-Host 'Press any key to continue...'
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
