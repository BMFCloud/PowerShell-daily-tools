# Upgrade Tools

Scripts to stop and start services during patching, upgrades, or maintenance windows.

| Script                  | Purpose                                                      |
|------------------------|--------------------------------------------------------------|
| `UpgradeStopServices`  | Stop backend and web services, switch to maintenance mode    |
| `UpgradeStartServices` | Start all services, re-enable site, and trigger cache refresh |