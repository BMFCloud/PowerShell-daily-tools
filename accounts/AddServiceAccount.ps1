# AddServiceAccount.ps1
# Creates a local service account and adds it to the Administrators group.
# Intended for standalone or lab environments where domain accounts are not used.
# Automatically launches a command session under the new account for verification.

# Author: Brandon Fortunato
# Created: 04/29/2024

$accountName = "svc_serviceaccount"
$password = "YourSecurePassword123!" | ConvertTo-SecureString -AsPlainText -Force

$user = New-LocalUser -Name $accountName -Password $password -AccountNeverExpires -UserMayNotChangePassword -PasswordNeverExpires
Add-LocalGroupMember -Group "Administrators" -Member $accountName

$credential = New-Object System.Management.Automation.PSCredential($accountName, $password)
Start-Process cmd.exe -Credential $credential -NoNewWindow