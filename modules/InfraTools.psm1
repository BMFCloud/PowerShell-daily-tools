function Set-AppHttpsEnforcement {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$FQDN,

        [Parameter(Mandatory=$true)]
        [string]$WebConfigPath,

        [Parameter(Mandatory=$true)]
        [string]$ComponentConfigPath,

        [Parameter(Mandatory=$true)]
        [string]$SqlConfigPath
    )

    Write-Host "Updating configuration files for HTTPS enforcement..."

    # Replace in web.config
    (Get-Content $WebConfigPath) -replace "http://$FQDN", "https://$FQDN" | Set-Content $WebConfigPath
    (Get-Content $WebConfigPath) -replace "http://localhost/Framework/SoapEventService.asmx", "https://localhost/Framework/SoapEventService.asmx" | Set-Content $WebConfigPath
    (Get-Content $WebConfigPath) -replace "https://$FQDN/Framework/Designer.asmx", "http://$FQDN/Framework/Designer.asmx" | Set-Content $WebConfigPath

    # Replace in sqlservr.exe.config
    (Get-Content $SqlConfigPath) -replace "http://127.0.0.1/Framework/ManagedModules.asmx", "https://$FQDN/Framework/ManagedModules.asmx" | Set-Content $SqlConfigPath

    # Replace in components config
    (Get-Content $ComponentConfigPath) -replace "http://$FQDN", "https://$FQDN" | Set-Content $ComponentConfigPath

    Write-Host "✔️ HTTPS updates applied to all config files."
}