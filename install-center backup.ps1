# ========================================

# BANLIE INSTALL CENTER v5

# BanlieComp @ 2026

# ========================================

$base = "https://raw.githubusercontent.com/banliecomputing/install-center/main/modules"

# ================= UI =================

function Show-Header {

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

try {

$cpu=(Get-WmiObject Win32_Processor).Name
$ram=[math]::Round((Get-WmiObject Win32_ComputerSystem).TotalPhysicalMemory/1GB,2)
$os=(Get-WmiObject Win32_OperatingSystem).Caption
$time=Get-Date -Format "dd MMM yyyy HH:mm:ss"

Write-Host "OS   : $os"
Write-Host "CPU  : $cpu"
Write-Host "RAM  : $ram GB"
Write-Host "TIME : $time"

}catch{}

Write-Host ""
Write-Host "===================================" -ForegroundColor DarkGray
Write-Host ""

}

function PauseMenu {

Write-Host ""
Read-Host "Press ENTER to continue"

}

# ================= WINGET =================

function Test-Winget {

$winget=Get-Command winget -ErrorAction SilentlyContinue

if($winget){return $true}else{return $false}

}

# ================= MODULE LOADER =================

try{

$modules=@(

"windows-tools.ps1",
"apps.ps1",
"tweaks.ps1",
"online-scripts.ps1",
"diagnostic.ps1"

)

foreach($m in $modules){

irm "$base/$m" | iex

}

}catch{

Write-Host "Module load failed." -ForegroundColor Red
Pause
return

}

# ================= MAIN MENU =================

function Show-MainMenu{

while($true){

Show-Header

Write-Host "MAIN MENU"
Write-Host ""

Write-Host "1. Windows Tools"
Write-Host "2. Applications Installer"
Write-Host "3. Tweaks & Optimization"
Write-Host "4. Online Scripts"
Write-Host "5. Hardware Diagnostic"
Write-Host ""
Write-Host "0. Exit"
Write-Host ""

$choice=Read-Host "Select"

switch($choice){

"1"{Show-WindowsTools}
"2"{Show-Apps}
"3"{Show-Tweaks}
"4"{Show-OnlineScripts}
"5"{Show-Diagnostic}

"0"{return}

}

}

}

Show-MainMenu
