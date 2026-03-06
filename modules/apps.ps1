function Install-App($wingetID,$url,$file){

Write-Host ""
Write-Host "Preparing install: $wingetID" -ForegroundColor Cyan

if(Test-Winget){

Write-Host "Installing using Winget..." -ForegroundColor Green
winget install -e --id $wingetID --silent --accept-package-agreements --accept-source-agreements

}else{

if(!$url){
Write-Host "No download URL provided." -ForegroundColor Red
return
}

Write-Host "Winget not found. Downloading installer..." -ForegroundColor Yellow

$temp="$env:TEMP\$file"

Invoke-WebRequest $url -OutFile $temp

Write-Host "Running installer..." -ForegroundColor Green
Start-Process $temp -Wait

}

Write-Host "Finished installing $wingetID" -ForegroundColor Green

}

function Show-Apps {

while ($true) {

Show-Header

Write-Host "APPLICATION INSTALLER" -ForegroundColor Green
Write-Host ""

Write-Host "==== Browser Windows ====" -ForegroundColor Yellow
Write-Host "1. Install Google Chrome"
Write-Host "2. Mozilla Firefox"
Write-Host ""

Write-Host "==== Tools ====" -ForegroundColor Yellow
Write-Host "3. Install 7zip"
Write-Host "4. Acrobat Reader"
Write-Host "5. WinRAR LAB"
Write-Host ""

Write-Host "==== Media Viewer ====" -ForegroundColor Yellow
Write-Host "6. Aimp Player"
Write-Host "7. Install VLC"
Write-Host ""

Write-Host "8. Install ALL Basic Apps"
Write-Host ""
Write-Host "0. Back"
Write-Host ""

$choice = Read-Host "Select"

switch ($choice) {

"1" {
Install-App "Google.Chrome" "https://dl.google.com/chrome/install/latest/chrome/install.exe" "chrome.exe"
PauseMenu
}

"2" {
Install-App "Mozilla.Firefox" "https://download.mozilla.org/?product=firefox-latest&os=win&lang=en-US" "firefox.exe"
PauseMenu
}

"3" {
Install-App "7zip.7zip" "https://www.7-zip.org/a/7z2301-x64.exe" "7zip.exe"
PauseMenu
}

"4" {
Install-App "Adobe.Acrobat.Reader.64-bit" "https://ardownload2.adobe.com/pub/adobe/reader/win/AcrobatDC/AcroRdrDCx64.exe" "reader.exe"
PauseMenu
}

"5" {
Install-App "RARLab.WinRAR" "https://www.rarlab.com/rar/winrar-x64.exe" "winrar.exe"
PauseMenu
}

"6" {
Install-App "AIMP.AIMP" "https://www.aimp.ru/?do=download.file&id=2" "aimp.exe"
PauseMenu
}

"7" {
Install-App "VideoLAN.VLC" "https://get.videolan.org/vlc/last/win64/vlc-win64.exe" "vlc.exe"
PauseMenu
}

"8" {

Write-Host ""
Write-Host "Installing ALL Basic Apps..." -ForegroundColor Cyan

Install-App "Google.Chrome" "https://dl.google.com/chrome/install/latest/chrome/install.exe" "chrome.exe"
Install-App "7zip.7zip" "https://www.7-zip.org/a/7z2301-x64.exe" "7zip.exe"
Install-App "VideoLAN.VLC" "https://get.videolan.org/vlc/last/win64/vlc-win64.exe" "vlc.exe"
Install-App "RARLab.WinRAR" "https://www.rarlab.com/rar/winrar-x64.exe" "winrar.exe"
Install-App "AIMP.AIMP" "https://www.aimp.ru/?do=download.file&id=2" "aimp.exe"

PauseMenu

}

"0" { return }

}

}

}
