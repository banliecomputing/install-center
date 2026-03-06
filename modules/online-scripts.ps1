function Show-OnlineScripts {

$scripts = @{

"1" = @{
Name = "Microsoft Activation Script (MAS)"
Url  = "https://get.activated.win"
}

"2" = @{
Name = "Windows Utility - Chris Titus"
Url  = "https://christitus.com/win"
}

"3" = @{
Name = "Auto Driver Updater W10/W11"
Url  = "https://raw.githubusercontent.com/banliecomputing/install-center/main/modules/Auto-Driver-Updater-W10.ps1"
}

"4" = @{
Name = "Windows Debloat Tool"
Url  = "https://debloat.raphi.re/"
}

"5" = @{
Name = "Office Installer Tool"
Url  = "https://officetool.plus/otool/otool.ps1"
}

"6" = @{
Name = "Reset Windows Update"
Url  = "https://raw.githubusercontent.com/wureset-tools/windows-update-reset/main/reset.ps1"
}

"7" = @{
Name = "Microsoft PC Manager Download"
Url  = "https://pcmanager.microsoft.com"
}

}

while ($true) {

Show-Header

Write-Host "========== ONLINE SCRIPT CENTER ==========" -ForegroundColor Cyan
Write-Host ""
Write-Host "Remote tools executed directly from internet"
Write-Host ""

foreach ($key in ($scripts.Keys | Sort-Object)) {

Write-Host "$key. $($scripts[$key].Name)"

}

Write-Host ""
Write-Host "0. Back"
Write-Host ""

$choice = Read-Host "Select"

if ($choice -eq "0") { return }

if ($scripts.ContainsKey($choice)) {

Show-Header

Write-Host "Launching $($scripts[$choice].Name)" -ForegroundColor Yellow
Write-Host ""

try {

irm $scripts[$choice].Url | iex

}catch{

Write-Host "Failed to execute script." -ForegroundColor Red

}

PauseMenu

}else{

Write-Host "Invalid choice" -ForegroundColor Red
Start-Sleep 1

}

}

}
