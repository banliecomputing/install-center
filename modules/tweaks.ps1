function Show-Tweaks {

while ($true) {

Show-Header

Write-Host "========== WINDOWS TWEAKS ==========" -ForegroundColor Magenta
Write-Host ""

Write-Host "1. Enable Dark Mode"
Write-Host "2. Show File Extensions"
Write-Host "3. Disable Windows Telemetry"
Write-Host "4. Disable Startup Delay"
Write-Host "5. Disable Windows Tips"
Write-Host ""
Write-Host "===== PERFORMANCE =====" -ForegroundColor Yellow
Write-Host "6. Enable Ultimate Performance"
Write-Host "7. Disable Background Apps"
Write-Host ""
Write-Host "===== EXPLORER =====" -ForegroundColor Yellow
Write-Host "8. Show Hidden Files"
Write-Host "9. Disable Shortcut Arrow"
Write-Host ""
Write-Host "0. Back"
Write-Host ""

$choice = Read-Host "Select"

switch ($choice) {

"1" {

Show-Header

Set-ItemProperty `
-Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize `
-Name AppsUseLightTheme -Value 0

Set-ItemProperty `
-Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize `
-Name SystemUsesLightTheme -Value 0

Write-Host "Dark Mode Enabled" -ForegroundColor Green

PauseMenu
}

"2" {

Show-Header

Set-ItemProperty `
-Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced `
-Name HideFileExt -Value 0

Write-Host "File Extensions Enabled" -ForegroundColor Green

PauseMenu
}

"3" {

Show-Header

New-ItemProperty `
-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" `
-Name "AllowTelemetry" `
-PropertyType DWord `
-Value 0 -Force

Write-Host "Telemetry Disabled" -ForegroundColor Green

PauseMenu
}

"4" {

Show-Header

Set-ItemProperty `
-Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize" `
-Name StartupDelayInMSec `
-Value 0 -Force

Write-Host "Startup Delay Disabled" -ForegroundColor Green

PauseMenu
}

"5" {

Show-Header

Set-ItemProperty `
-Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" `
-Name SubscribedContent-338389Enabled `
-Value 0

Write-Host "Windows Tips Disabled" -ForegroundColor Green

PauseMenu
}

"6" {

Show-Header

powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61

Write-Host "Ultimate Performance Enabled" -ForegroundColor Green

PauseMenu
}

"7" {

Show-Header

Set-ItemProperty `
-Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" `
-Name GlobalUserDisabled `
-Value 1

Write-Host "Background Apps Disabled" -ForegroundColor Green

PauseMenu
}

"8" {

Show-Header

Set-ItemProperty `
-Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced `
-Name Hidden `
-Value 1

Write-Host "Hidden Files Enabled" -ForegroundColor Green

PauseMenu
}

"9" {

Show-Header

reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v 29 /t REG_SZ /d "" /f

Stop-Process -Name explorer -Force
Start-Process explorer

Write-Host "Shortcut Arrow Removed" -ForegroundColor Green

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
