function Show-Diagnostic {

while ($true) {

Show-Header

Write-Host "====== HARDWARE DIAGNOSTIC ======" -ForegroundColor Green
Write-Host ""

Write-Host "1. System Information"
Write-Host "2. Disk Health"
Write-Host "3. Battery Report"
Write-Host "4. Network Reset"
Write-Host "5. Keyboard Tester"

Write-Host ""
Write-Host "===== ADVANCED DIAGNOSTIC =====" -ForegroundColor Yellow

Write-Host "6. CPU / GPU Information"
Write-Host "7. Disk SMART Detail"
Write-Host "8. Internet Speed Test"
Write-Host "9. Windows Activation Status"
Write-Host "10. DirectX Diagnostic"

Write-Host ""
Write-Host "0. Back"
Write-Host ""

$choice = Read-Host "Select"

switch ($choice) {

"1" {

Show-Header
Write-Host "SYSTEM INFORMATION" -ForegroundColor Cyan
Write-Host ""

systeminfo

Pause
}

"2" {

Show-Header
Write-Host "DISK HEALTH STATUS" -ForegroundColor Cyan
Write-Host ""

wmic diskdrive get model,status

Pause
}

"3" {

Show-Header
Write-Host "BATTERY REPORT" -ForegroundColor Cyan
Write-Host ""

powercfg /batteryreport

Start-Process "$env:USERPROFILE\battery-report.html"

Pause
}

"4" {

Show-Header
Write-Host "RESETTING NETWORK..." -ForegroundColor Yellow
Write-Host ""

netsh winsock reset
netsh int ip reset
ipconfig /flushdns

Write-Host ""
Write-Host "Network Reset Completed" -ForegroundColor Green

Pause
}

"5" {

Show-Header
Write-Host "KEYBOARD TESTER" -ForegroundColor Cyan
Write-Host ""

if (Test-Path ".\keyboardtester.exe") {

Start-Process "keyboardtester.exe"

}else{

Write-Host "keyboardtester.exe not found in current folder." -ForegroundColor Red

}

Pause
}

"6" {

Show-Header
Write-Host "CPU / GPU INFORMATION" -ForegroundColor Cyan
Write-Host ""

Get-CimInstance Win32_Processor | Select Name,NumberOfCores,MaxClockSpeed

Write-Host ""

Get-CimInstance Win32_VideoController | Select Name,DriverVersion,AdapterRAM

Pause
}

"7" {

Show-Header
Write-Host "DISK SMART DETAIL" -ForegroundColor Cyan
Write-Host ""

wmic diskdrive get model,serialnumber,size,status

Pause
}

"8" {

Show-Header
Write-Host "INTERNET SPEED TEST" -ForegroundColor Cyan
Write-Host ""

Write-Host "Opening speed test in browser..." -ForegroundColor Yellow

Start-Process "https://fast.com"

Pause
}

"9" {

Show-Header
Write-Host "WINDOWS ACTIVATION STATUS" -ForegroundColor Cyan
Write-Host ""

slmgr /xpr

Pause
}

"10" {

Show-Header
Write-Host "DIRECTX DIAGNOSTIC TOOL" -ForegroundColor Cyan
Write-Host ""

Start-Process "dxdiag"

Pause
}

"0" { return }

default {

Write-Host "Invalid choice" -ForegroundColor Red
Start-Sleep 1

}

}

}

}
