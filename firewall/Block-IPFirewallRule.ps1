# Block-IPFirewallRule.ps1
# Quickly applies a local Windows Firewall rule to block inbound access from a specific IP address.
# Useful for temporarily restricting access during cache loads, system restarts, or controlled maintenance windows.

# Author: Brandon Fortunato
# Created: 09/22/2020




Set-NetFirewallProfile -Profile Public,Private -Enabled True
 
Set-NetFirewallRule -DisplayName "World Wide Web Services (HTTPS Traffic-In)" -Direction Inbound -Action Block 
Set-NetFirewallRule -DisplayName "World Wide Web Services (HTTP Traffic-In)" -Direction Inbound -Action Block  

Read-Host -Prompt "Program will now delay......When ready, press Enter to Disable Firewall/Open up all ports...  "

Write-Host 'Firewall will be disabled and Rules will be removed. '

Set-NetFirewallRule -DisplayName "World Wide Web Services (HTTPS Traffic-In)" -Direction Inbound -Action Allow 
Set-NetFirewallRule -DisplayName "World Wide Web Services (HTTP Traffic-In)" -Direction Inbound -Action Allow 

Set-NetFirewallProfile -Profile Public,Private -Enabled False

Read-Host  -Prompt 'Site is now accepting inbound requests.  Press any key to exit. '