# InfraTools.psm1
# PowerShell Toolkit Module
# Author: Brandon Fortunato

# -------------------------------
# Set-AppHttpsEnforcement
# -------------------------------
function Set-AppHttpsEnforcement {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$FQDN,

        [Parameter(Mandatory = $true)]
        [string]$WebConfigPath,

        [Parameter(Mandatory = $true)]
        [string]$ComponentConfigPath,

        [Parameter(Mandatory = $true)]
        [string]$SqlConfigPath
    )

    Write-Host "Updating configuration files for HTTPS enforcement..."

    (Get-Content $WebConfigPath) -replace "http://$FQDN", "https://$FQDN" | Set-Content $WebConfigPath
    (Get-Content $WebConfigPath) -replace "http://localhost/Framework/SoapEventService.asmx", "https://localhost/Framework/SoapEventService.asmx" | Set-Content $WebConfigPath
    (Get-Content $WebConfigPath) -replace "https://$FQDN/Framework/Designer.asmx", "http://$FQDN/Framework/Designer.asmx" | Set-Content $WebConfigPath

    (Get-Content $SqlConfigPath) -replace "http://127.0.0.1/Framework/ManagedModules.asmx", "https://$FQDN/Framework/ManagedModules.asmx" | Set-Content $SqlConfigPath
    (Get-Content $ComponentConfigPath) -replace "http://$FQDN", "https://$FQDN" | Set-Content $ComponentConfigPath

    Write-Host "✔️ HTTPS updates applied to all config files."
}

# -------------------------------
# Export-GuidBatchFiles
# -------------------------------
function Export-GuidBatchFiles {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$SqlServer = "localhost",

        [Parameter(Mandatory = $true)]
        [string]$Database = "YourDatabase",

        [Parameter(Mandatory = $true)]
        [string]$Query,

        [Parameter(Mandatory = $true)]
        [string]$OutputFolder,

        [string]$LogFolder = "$PSScriptRoot\logs"
    )

    if (-not (Test-Path $LogFolder)) { New-Item -ItemType Directory -Path $LogFolder | Out-Null }
    if (-not (Test-Path $OutputFolder)) { New-Item -ItemType Directory -Path $OutputFolder | Out-Null }

    $date = Get-Date -Format "yyyy-MM-dd"
    $logfile = Join-Path $LogFolder "$date.log"

    function Write-Log {
        param ([string]$Message)
        "$((Get-Date).ToString('u')) $Message" | Out-File $logfile -Append
    }

    Write-Log "Executing query against $Database on $SqlServer"
    $results = Invoke-Sqlcmd -ServerInstance $SqlServer -Database $Database -Query $Query -ErrorAction Stop

    Write-Log "Retrieved $($results.Count) results."

    foreach ($row in $results) {
        $guid = $row[0].ToString().Trim()
        if (-not [string]::IsNullOrWhiteSpace($guid)) {
            $filePath = Join-Path $OutputFolder "$guid.txt"
            Set-Content -Path $filePath -Value $guid
        }
    }

    Write-Log "All individual GUID files written to $OutputFolder"
}

# -------------------------------
# Copy-NetworkFolders
# -------------------------------
function Copy-NetworkFolders {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$SourcePrefix,

        [Parameter(Mandatory = $true)]
        [string]$DestPrefix,

        [Parameter(Mandatory = $true)]
        [string]$Username,

        [string]$LogFolder = "$PSScriptRoot\logs"
    )

    $paths = @(
        @{ Name = "SharedRoot"; Source = "\\$SourcePrefix\SharedRoot"; Dest = "\\$DestPrefix\SharedRoot"; Log = "SharedRoot.log" },
        @{ Name = "Backup"; Source = "\\$SourcePrefix\Backup"; Dest = "\\$DestPrefix\Backup"; Log = "Backup.log" },
        @{ Name = "Documents"; Source = "\\$SourcePrefix\c$\Users\$Username\Documents"; Dest = "\\$DestPrefix\c$\Users\$Username\Documents"; Log = "Documents.log" },
        @{ Name = "Desktop"; Source = "\\$SourcePrefix\c$\Users\$Username\Desktop"; Dest = "\\$DestPrefix\c$\Users\$Username\Desktop"; Log = "Desktop.log" }
    )

    if (-not (Test-Path $LogFolder)) {
        New-Item -ItemType Directory -Path $LogFolder | Out-Null
    }

    foreach ($item in $paths) {
        $logPath = Join-Path $LogFolder $item.Log
        Write-Host "Starting copy: $($item.Source) -> $($item.Dest)"
        Start-Process robocopy -ArgumentList "`"$($item.Source)`" `"$($item.Dest)`" /MIR /FFT /XO /Z /W:3 /TEE /LOG+:$logPath" -NoNewWindow -Wait
        Write-Host "Finished: $($item.Name)"
    }
}
# -------------------------------
# Copy-NetworkFoldersLive
# -------------------------------
function Copy-NetworkFoldersLive {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$SourcePrefix,

        [Parameter(Mandatory = $true)]
        [string]$DestPrefix,

        [Parameter(Mandatory = $true)]
        [string]$Username,

        [string]$LogFolder = "$PSScriptRoot\logs"
    )

    $paths = @(
        @{ Name = "SharedRoot"; Source = "\\$SourcePrefix\SharedRoot"; Dest = "\\$DestPrefix\SharedRoot"; Log = "SharedRootLive.log" },
        @{ Name = "Backup"; Source = "\\$SourcePrefix\Backup"; Dest = "\\$DestPrefix\Backup"; Log = "BackupLive.log" },
        @{ Name = "Documents"; Source = "\\$SourcePrefix\c$\Users\$Username\Documents"; Dest = "\\$DestPrefix\c$\Users\$Username\Documents"; Log = "DocumentsLive.log" },
        @{ Name = "Desktop"; Source = "\\$SourcePrefix\c$\Users\$Username\Desktop"; Dest = "\\$DestPrefix\c$\Users\$Username\Desktop"; Log = "DesktopLive.log" }
    )

    if (-not (Test-Path $LogFolder)) {
        New-Item -ItemType Directory -Path $LogFolder | Out-Null
    }

    foreach ($item in $paths) {
        $logPath = Join-Path $LogFolder $item.Log
        Write-Host "Starting live monitor: $($item.Source) -> $($item.Dest)"
        Start-Process robocopy -ArgumentList "`"$($item.Source)`" `"$($item.Dest)`" /MIR /MON:1 /FFT /XO /Z /W:3 /TEE /LOG+:$logPath" -NoNewWindow -Wait
        Write-Host "Monitoring started for: $($item.Name)"
    }
}
# -------------------------------
# Get-SpeculationMitigationStatus
# -------------------------------
function Get-SpeculationMitigationStatus {
    [CmdletBinding()]
    param ()

    $output = @()

    $regPaths = @(
        "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management",
        "HKLM:\HARDWARE\DESCRIPTION\System\CentralProcessor\0",
        "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Virtualization"
    )

    foreach ($path in $regPaths) {
        if (Test-Path $path) {
            $props = Get-ItemProperty -Path $path | Select-Object *
            $output += "=== $path ==="
            $props.PSObject.Properties | ForEach-Object {
                $output += "$($_.Name): $($_.Value)"
            }
            $output += ""
        }
    }

    try {
        $speculationCmd = Get-Command Get-SpeculationControlSettings -ErrorAction SilentlyContinue
        if ($speculationCmd) {
            $output += "=== Get-SpeculationControlSettings Results ==="
            $result = Get-SpeculationControlSettings
            $output += $result | Out-String
        } else {
            $output += "Get-SpeculationControlSettings cmdlet not available. Install it via Windows update or manual import."
        }
    } catch {
        $output += "Error executing Get-SpeculationControlSettings: $_"
    }

    return $output -join "`n"
}
