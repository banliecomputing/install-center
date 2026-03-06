function Show-Diagnostic {

while ($true) {

Clear-Host

Write-Host "====== HARDWARE DIAGNOSTIC ======"
Write-Host ""
Write-Host "1. System Information"
Write-Host "2. Disk Health"
Write-Host "3. Battery Report"
Write-Host "4. Network Reset"
Write-Host "5. Keyboard Tester"
Write-Host ""
Write-Host "0. Back"
Write-Host ""

$choice = Read-Host "Select"

switch ($choice) {

"1" {

systeminfo

}

"2" {

wmic diskdrive get status

}

"3" {

powercfg /batteryreport
Start-Process "$env:USERPROFILE\battery-report.html"

}

"4" {

netsh winsock reset
netsh int ip reset
ipconfig /flushdns

Write-Host "Network Reset Completed"

}

"5" {

Start-Process "keyboardtester.exe"

}

"0" { return }

}

Pause

}

}
