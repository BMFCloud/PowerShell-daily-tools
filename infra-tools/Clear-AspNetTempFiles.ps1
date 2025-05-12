

#This Powershell script was designed to complete task "CLEAR ASP.NET FOLDER CACHE" within the Comprehensive Build guide.
#Overview: Stops IIS, removes temp files within .Net Framework folder, Starts IIS service back up
#Creator: Brandon Fortunato
#Created on 5/13/2019

IISreset /stop     

$fullpath = Join-Path "C:" -ChildPath "Windows" | Join-Path -ChildPath "Microsoft.NET" | Join-Path -ChildPath "Framework64"| Join-Path -ChildPath "v4.0.30319"| Join-Path -ChildPath "Temporary ASP.NET Files"| Join-Path -ChildPath "root\*"

Write-Output "File path is" $fullpath 

Remove-Item $fullpath -Recurse -Force 

Write-Output "Deletion of Temp ASP.Net files complete...Restarting IIS"

iisreset /start

Read-Host -Prompt "Press Enter to Exit"