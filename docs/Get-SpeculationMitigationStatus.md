# Get-SpeculationMitigationStatus

## 🧠 What It Does
Pulls registry and system data related to Spectre and Meltdown CPU vulnerability mitigations. Uses registry keys and optionally the `Get-SpeculationControlSettings` cmdlet if available.

## 💡 Why It Exists
Windows Server and workstation platforms may not expose their speculation mitigation status clearly. This function checks related registry keys and gathers relevant system information in one place.

## 📋 Output
Returns a readable string of registry values and hardware flags tied to:

- Branch prediction (Spectre)
- Kernel VA Shadowing (Meltdown)
- Hypervisor settings

## 🚀 Example

```powershell
Import-Module ./Modules/InfraTools.psm1
Get-SpeculationMitigationStatus
```

---

Author: Brandon Fortunato