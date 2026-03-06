# ============================================

# BANLIE INSTALL CENTER v4

# BanlieComp @ 2026

# ============================================

$base = "https://raw.githubusercontent.com/banliecomputing/install-center/main/modules"

# ===== UI =====

function Show-Logo {

Clear-Host

Write-Host ""
Write-Host "██████╗  █████╗ ███╗   ██╗██╗     ██╗███████╗" -ForegroundColor Cyan
Write-Host "██╔══██╗██╔══██╗████╗  ██║██║     ██║██╔════╝" -ForegroundColor Cyan
Write-Host "██████╔╝███████║██╔██╗ ██║██║     ██║█████╗  " -ForegroundColor Cyan
Write-Host "██╔══██╗██╔══██║██║╚██╗██║██║     ██║██╔══╝  " -ForegroundColor Cyan
Write-Host "██████╔╝██║  ██║██║ ╚████║███████╗██║███████╗" -ForegroundColor Cyan
Write-Host "╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚═╝╚══════╝" -ForegroundColor Cyan

Write-Host ""
Write-Host "BanlieComp @ 2026" -ForegroundColor Yellow
Write-Host ""
}

# ===== SYSTEM INFO =====

function Show-SystemInfo {

try {

$cpu = (Get-WmiObject Win32_Processor).Name
$ram = [math]::Round((Get-WmiObject Win32_ComputerSystem).TotalPhysicalMemory /1GB,2)
$os = (Get-WmiObject Win32_OperatingSystem).Caption
$disk = Get-WmiObject Win32_LogicalDisk -Filter "DeviceID='C:'"
$free = [math]::Round($disk.FreeSpace/1GB,1)

}
catch {

$cpu="Unknown"
$ram="?"
$os="Windows"
$free="?"

}

$time = Get-Date -Format "dd MMM yyyy  HH:mm:ss"

Write-Host "===== SYSTEM =====" -ForegroundColor Green
Write-Host "Time : $time"
Write-Host "OS   : $os"
Write-Host "CPU  : $cpu"
Write-Host "RAM  : $ram GB"
Write-Host "Disk : $free GB free"
Write-Host ""
}

# ===== WINGET CHECK =====

function Test-Winget {

$winget = Get-Command winget -ErrorAction SilentlyContinue

if ($winget) {
return $true
}
else {
return $false
}

}

# ===== MODULE LOADER =====

try {

$modules = @(
"windows-tools.ps1",
"apps.ps1",
"tweaks.ps1",
"online-scripts.ps1",
"diagnostic.ps1"
)

foreach ($m in $modules) {
irm "$base/$m" | iex
}

}
catch {

Write-Host "Module loading failed." -ForegroundColor Red
Pause
return

}

# ===== MAIN MENU =====

function Show-MainMenu {

while ($true) {

Show-Logo
Show-SystemInfo

Write-Host "=========== MENU ===========" -ForegroundColor White
Write-Host ""
Write-Host "1. Windows Tools" -ForegroundColor Cyan
Write-Host "2. Applications Installer" -ForegroundColor Magenta
Write-Host "3. Tweaks & Optimization" -ForegroundColor Yellow
Write-Host "4. Online Scripts" -ForegroundColor Red
Write-Host "5. Hardware Diagnostic" -ForegroundColor Green
Write-Host ""
Write-Host "0. Exit"
Write-Host ""

$choice = Read-Host "Select Menu"

switch ($choice) {

"1" { Show-WindowsTools }

"2" { Show-Apps }

"3" { Show-Tweaks }

"4" { Show-OnlineScripts }

"5" { Show-Diagnostic }

"0" { return }

default {

Write-Host "Invalid choice"
Start-Sleep 1

}

}

}

}

Show-MainMenu
