# AutoClean PowerShell Script
# Cleans system temp folders and app cache; logs all actions

$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$logDir = "$PSScriptRoot\logs"
$logFile = "$logDir\autoclean.log"

# Ensure log directory exists
if (!(Test-Path $logDir)) {
    New-Item -Path $logDir -ItemType Directory | Out-Null
}

function Log {
    param ([string]$message)
    $entry = "$(Get-Date -Format "yyyy-MM-dd HH:mm:ss") $message"
    $entry | Out-File -Append -FilePath $logFile
    Write-Host $entry
}

function Clean-Folder {
    param ([string]$Path, [string]$Label)

    if (!(Test-Path $Path)) {
        Log "[SKIPPED] $Label not found: $Path"
        return
    }

    $filesDeleted = 0
    try {
        Get-ChildItem -Path $Path
