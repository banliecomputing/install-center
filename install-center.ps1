# =============================

# BANLIE INSTALL CENTER v3

# BanlieComp @ 2026

# =============================

$base = "https://raw.githubusercontent.com/banliecomputing/install-center/main/modules"

# ===== UI FUNCTIONS =====

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

function Show-SystemInfo {

$cpu = (Get-WmiObject Win32_Processor).Name
$ram = [math]::Round((Get-WmiObject Win32_ComputerSystem).TotalPhysicalMemory /1GB,2)
$os = (Get-WmiObject Win32_OperatingSystem).Caption
$time = Get-Date -Format "dddd, dd MMMM yyyy  HH:mm:ss"

Write-Host "===== SYSTEM INFO =====" -ForegroundColor Green
Write-Host "Time : $time"
Write-Host "OS   : $os"
Write-Host "CPU  : $cpu"
Write-Host "RAM  : $ram GB"
Write-Host ""

}

function PauseMenu {
Write-Host ""
Read-Host "Press ENTER to return"
}

# ===== LOAD MODULES =====

try {

$modules = @(
"windows-tools.ps1",
"apps.ps1",
"tweaks.ps1",
"online-scripts.ps1"
)

foreach ($m in $modules) {
irm "$base/$m" | iex
}

}
catch {

Write-Host "Failed loading modules." -ForegroundColor Red
Pause
return

}

# ===== MAIN MENU =====

function Show-MainMenu {

while ($true) {

Show-Logo
Show-SystemInfo

Write-Host "========== MAIN MENU ==========" -ForegroundColor White
Write-Host ""
Write-Host "1. Windows Tools" -ForegroundColor Cyan
Write-Host "2. Applications" -ForegroundColor Magenta
Write-Host "3. Tweaks" -ForegroundColor Yellow
Write-Host "4. Online Scripts" -ForegroundColor Red
Write-Host ""
Write-Host "0. Exit"
Write-Host ""

$choice = Read-Host "Select Menu"

switch ($choice) {

"1" { Show-WindowsTools }
"2" { Show-Apps }
"3" { Show-Tweaks }
"4" { Show-OnlineScripts }

"0" { return }

default {

Write-Host "Invalid selection"
Start-Sleep 1

}

}

}

}

Show-MainMenu
