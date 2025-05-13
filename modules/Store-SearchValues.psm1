function Export-GuidBatchFiles {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$SqlServer = "localhost",

        [Parameter(Mandatory=$true)]
        [string]$Database = "YourDatabase",

        [Parameter(Mandatory=$true)]
        [string]$Query,

        [Parameter(Mandatory=$true)]
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