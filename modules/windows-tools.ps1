function Show-WindowsTools {

while ($true) {

Show-Header

Write-Host "========== WINDOWS TOOLS ==========" -ForegroundColor Yellow
Write-Host ""

Write-Host "1. System Information"
Write-Host "2. Disk Cleanup"
Write-Host "3. Check Disk (C:)"
Write-Host "4. SFC Scan"
Write-Host "5. DISM Repair"
Write-Host ""
Write-Host "===== UTILITIES =====" -ForegroundColor Cyan
Write-Host "6. Keyboard Tester Portable"
Write-Host "7. Auto Driver Updater (Windows 10/11)"
Write-Host ""
Write-Host "===== NETWORK =====" -ForegroundColor Cyan
Write-Host "8. Flush DNS"
Write-Host "9. Network Reset"
Write-Host ""
Write-Host "0. Back"
Write-Host ""

$choice = Read-Host "Select"

switch ($choice) {

"1" {

Show-Header
Write-Host "SYSTEM INFORMATION" -ForegroundColor Green
Write-Host ""

systeminfo

PauseMenu
}

"2" {

Show-Header
Write-Host "Opening Disk Cleanup..." -ForegroundColor Green
Write-Host ""

Start-Process cleanmgr

PauseMenu
}

"3" {

Show-Header
Write-Host "Checking Disk C:" -ForegroundColor Green
Write-Host ""

chkdsk C:

PauseMenu
}

"4" {

Show-Header
Write-Host "Running System File Checker..." -ForegroundColor Green
Write-Host ""

sfc /scannow

PauseMenu
}

"5" {

Show-Header
Write-Host "Running DISM Repair..." -ForegroundColor Green
Write-Host ""

DISM /Online /Cleanup-Image /RestoreHealth

PauseMenu
}

"6" {

Show-Header

$url = "https://github.com/banliecomputing/install-center/releases/download/v1.0/Keyboard.Test.Portable.exe"
$path = "$env:TEMP\keyboardtester.exe"

if (-not (Test-Path $path)) {

Write-Host "Downloading Keyboard Tester..." -ForegroundColor Yellow
Invoke-WebRequest $url -OutFile $path

}

Write-Host "Launching Keyboard Tester..." -ForegroundColor Green

Start-Process $path

PauseMenu
}

"7" {

Show-Header

Write-Host "Running Auto Driver Updater..." -ForegroundColor Green

try {

$url = "https://raw.githubusercontent.com/banliecomputing/install-center/main/modules/Auto-Driver-Updater-W10.ps1"
irm $url | iex

}
catch {

Write-Host "Failed to run Driver Updater" -ForegroundColor Red

}

PauseMenu
}

"8" {

Show-Header

Write-Host "Flushing DNS..." -ForegroundColor Green

ipconfig /flushdns

PauseMenu
}

"9" {

Show-Header

Write-Host "Resetting Network..." -ForegroundColor Yellow

netsh winsock reset
netsh int ip reset
ipconfig /flushdns

Write-Host ""
Write-Host "Network Reset Completed" -ForegroundColor Green

PauseMenu
}

"0" { return }

default {

Write-Host "Invalid choice" -ForegroundColor Red
Start-Sleep 1

}

}

}

}
