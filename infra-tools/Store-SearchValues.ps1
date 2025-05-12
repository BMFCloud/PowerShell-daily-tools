# Extract-UnprocessedRequisitions.ps1
# Purpose: Automates the extraction of unprocessed requisition GUIDs within a user-defined date range.
#
# Overview:
# - Accepts a start and end datetime range from the user.
# - Queries SQL for requisitions not yet processed within that range.
# - Logs all activity and saves the GUIDs to a .txt file.
# - Splits the GUID list into individual text files for manual ingestion or external tooling.
# - Final manual step is included by design to ensure validation before full ingestion.
#
# Notes:
# - Currently supports export to .txt files only.
# - Logs are saved to [BASE_LOG_PATH]\logs\
#
# Author: Brandon Fortunato
# Deployed: 09/26/2019

$datesstartstring = Read-Host "Please Enter Start Date/Time (Ex: 2019-08-04 04:00:00.000)"
$dateendstring = Read-Host "Please Enter End Date/Time (Ex: 2019-08-04 13:14:00.000)"

$date = Get-Date -Format "yyyy-MM-dd"
$Logfile = "[BASE_LOG_PATH]\\logs\\${date}.log"

function Get-TimeStamp {
    return "[{0:MM/dd/yy} {0:HH:mm:ss}]" -f (Get-Date)
}

Write-Output "$(Get-TimeStamp) The following variables have been defined: Start = ${datesstartstring}, End = ${dateendstring}" | Out-File $Logfile -Append
Write-Host "`n"

$ds = Get-Date $datesstartstring -Format "yyyy-MM-dd HH:mm:ss:fff"
$de = Get-Date $dateendstring -Format "yyyy-MM-dd HH:mm:ss:fff"

Write-Output "$(Get-TimeStamp) Dates formatted for query: Start = ${ds}, End = ${de}" | Out-File $Logfile -Append

Write-Host "Start Date/Time: $ds"
Write-Host "End Date/Time: $de"

$confirmation = Read-Host "*** Are you sure this information is correct? (y/n) ***"
while ($confirmation -ne "y") {
    if ($confirmation -eq "n") { exit }
    $confirmation = Read-Host "Please verify entry. [y/n]"
}

# Query to fetch unprocessed requisitions
$query = @"
SELECT DISTINCT [Column]
FROM [Database]..[Table]
WHERE [Column] IS NULL
  AND Deleted = 0
  AND DT_Created BETWEEN '$ds' AND '$de'
"@

# Output initial result list
Invoke-Sqlcmd -Query $query -ServerInstance "localhost" | Out-File "[BASE_PATH]\\Extractor\\ListGUIDS\\${date}_requisitions_raw.txt"
Write-Output "$(Get-TimeStamp) Returned list of GUIDs." | Out-File $Logfile -Append

# Clean and format output
(Get-Content "[BASE_PATH]\\Extractor\\ListGUIDS\\${date}_requisitions_raw.txt" | Select-Object -Skip 3 | Where-Object { $_.Trim() -ne "" }) | Set-Content "[BASE_PATH]\\Extractor\\ListGUIDS\\${date}_requisitions_final.txt"
Write-Output "$(Get-TimeStamp) Data cleaned and prepared for file generation." | Out-File $Logfile -Append

# Create individual .txt files for each GUID
foreach ($line in [System.IO.File]::ReadLines("[BASE_PATH]\\Extractor\\ListGUIDS\\${date}_requisitions_final.txt")) {
    New-Item -Force -Path "[BASE_PATH]\\Extractor\\CompletedFiles\\" -Name "$line.txt" -Value "$line" | Out-Null
}

Write-Output "$(Get-TimeStamp) Individual files generated. Located at \\Extractor\\CompletedFiles\\" | Out-File $Logfile -Append
