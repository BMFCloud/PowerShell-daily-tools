# Set-AppHttpsEnforcement

## 🔒 What It Does
Enforces HTTPS-only communication by rewriting configuration files that include hardcoded HTTP URLs.

## ⚙️ How It Works
This function updates:
- `web.config` entries
- `components.dll.config`
- `sqlservr.exe.config`

It replaces `http://` references with `https://` based on the provided FQDN and paths.

## 🧠 Why It Exists
Legacy app environments often contain hardcoded non-secure URLs. This script enables fast, repeatable conversion during upgrades or security hardening.

## 📦 Parameters

| Name                   | Description                          |
|------------------------|--------------------------------------|
| `$FQDN`                | The fully qualified domain name      |
| `$WebConfigPath`       | Path to `web.config`                 |
| `$ComponentConfigPath` | Path to `components.dll.config`      |
| `$SqlConfigPath`       | Path to `sqlservr.exe.config`        |

## 🚀 Example

```powershell
Import-Module ./Modules/InfraTools.psm1
Set-AppHttpsEnforcement -FQDN "app.example.com" `
    -WebConfigPath "C:\App\web.config" `
    -ComponentConfigPath "C:\App\Components\components.dll.config" `
    -SqlConfigPath "C:\SQL\sqlservr.exe.config"
```

---
Author: Brandon Fortunato