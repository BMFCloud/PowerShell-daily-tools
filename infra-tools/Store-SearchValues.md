# Export-GuidBatchFiles

## 📦 What It Does
Extracts a set of unique identifiers (e.g., GUIDs) from SQL using a custom query, logs the activity, and outputs each result to its own `.txt` file.

## 🧠 Why It Exists
Sometimes you need to batch-process large amounts of records manually — this lets you break them out by record, validate visually, and feed into separate systems.

## 🛠 Parameters

| Name         | Description                                 |
|--------------|---------------------------------------------|
| `SqlServer`  | SQL Server name or IP                       |
| `Database`   | Target database                             |
| `Query`      | SQL query to execute (should return 1 col)  |
| `OutputFolder` | Folder to save individual .txt files      |
| `LogFolder`  | Optional path for log output                |

## 🚀 Example

```powershell
Import-Module ./Modules/InfraTools.psm1

$customQuery = @"
SELECT DISTINCT RequisitionGuid
FROM Orders
WHERE CreatedDate BETWEEN '2024-01-01' AND '2024-01-31'
  AND Status = 'Pending'
"@

Export-GuidBatchFiles -SqlServer "localhost" `
    -Database "Procurement" `
    -Query $customQuery `
    -OutputFolder "C:\Data\BatchFiles"
```

---

Author: Brandon Fortunato