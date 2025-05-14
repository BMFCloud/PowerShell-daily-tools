# Copy-NetworkFoldersLive

## 🔁 What It Does
Performs continuous monitoring of network folder changes using `robocopy /MON:1` to automatically sync files from source to destination when updates occur.

## 🧠 Why It Exists
Use during live migration windows when files may change before final cutover. Keeps destination in sync with source while minimizing downtime.

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

Copy-NetworkFoldersLive -SourcePrefix "10.10.10.5" `
    -DestPrefix "10.10.10.6" `
    -Username "deployuser"
```

---

Author: Brandon Fortunato