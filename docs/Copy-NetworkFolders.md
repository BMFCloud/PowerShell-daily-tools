# Copy-NetworkFolders

## 🧭 What It Does
Automates `robocopy` file migration across standard folders like `SharedRoot`, `Backup`, `Documents`, and `Desktop`.

## 🧠 Why It Exists
Designed for closed-network migrations and upgrades where consistency and log visibility matter. Ensures repeatable folder mirroring across environments.

## ⚙️ Parameters

| Name           | Description                                            |
|----------------|--------------------------------------------------------|
| `SourcePrefix` | IP or hostname of the source system                    |
| `DestPrefix`   | IP or hostname of the destination system               |
| `Username`     | Local or domain username used in `C:\Users` path      |
| `LogFolder`    | Path to save logs (default: `./logs`)                  |

## 🚀 Example

```powershell
Import-Module ./Modules/InfraTools.psm1

Copy-NetworkFolders -SourcePrefix "10.10.10.5" `
    -DestPrefix "10.10.10.6" `
    -Username "deployuser"
```

---

Author: Brandon Fortunato