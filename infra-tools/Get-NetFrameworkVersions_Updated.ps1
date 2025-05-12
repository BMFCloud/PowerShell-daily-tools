# Get-NetFrameworkVersions.ps1
# Updated for .NET Framework releases through 4.8.1 (as of 2024)

function Get-DotNetVersion {
    $keys = @(
        "HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full",
        "HKLM:\SOFTWARE\WOW6432Node\Microsoft\NET Framework Setup\NDP\v4\Full"
    )

    foreach ($key in $keys) {
        if (Test-Path $key) {
            $release = (Get-ItemProperty $key).Release
            if ($release) {
                Write-Host "Detected Release: $release"

                switch ($release) {
                    { $_ -ge 533325 } { return "4.8.1 (Windows 11/Server 2022)" }
                    { $_ -ge 533320 } { return "4.8.1" }
                    { $_ -ge 528040 } { return "4.8" }
                    { $_ -ge 461814 } { return "4.7.2 (Windows 10 April 2018 update or later)" }
                    { $_ -ge 461808 } { return "4.7.2" }
                    { $_ -ge 461310 } { return "4.7.1" }
                    { $_ -ge 461308 } { return "4.7.1" }
                    { $_ -ge 460805 } { return "4.7" }
                    { $_ -ge 460798 } { return "4.7" }
                    { $_ -ge 394806 } { return "4.6.2" }
                    { $_ -ge 394802 } { return "4.6.2" }
                    { $_ -ge 394271 } { return "4.6.1" }
                    { $_ -ge 394254 } { return "4.6.1" }
                    { $_ -ge 393297 } { return "4.6" }
                    { $_ -ge 393295 } { return "4.6" }
                    { $_ -ge 379893 } { return "4.5.2" }
                    { $_ -ge 378758 } { return "4.5.1" }
                    { $_ -ge 378675 } { return "4.5.1" }
                    { $_ -ge 378389 } { return "4.5" }
                    default { return "Unknown or earlier than 4.5" }
                }
            }
        }
    }

    return "No .NET Framework 4.5 or later detected"
}

Write-Host ("Installed .NET Framework Version: " + (Get-DotNetVersion))