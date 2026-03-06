function Install-App($wingetID,$url,$file){

if(Test-Winget){

Write-Host "Installing via Winget..." -ForegroundColor Cyan
winget install -e --id $wingetID --silent

}else{

Write-Host "Downloading installer..." -ForegroundColor Yellow

$temp="$env:TEMP$file"

Invoke-WebRequest $url -OutFile $temp

Start-Process $temp -Wait

}

}

function Show-Apps{

while($true){

Show-Header

Write-Host "APPLICATION INSTALLER"
Write-Host ""

Write-Host "BROWSER"
Write-Host "1. Google Chrome"
Write-Host "2. Mozilla Firefox"
Write-Host ""

Write-Host "TOOLS"
Write-Host "3. 7zip"
Write-Host "4. Acrobat Reader"
Write-Host "5. WinRAR"
Write-Host ""

Write-Host "MEDIA"
Write-Host "6. AIMP Player"
Write-Host "7. VLC Player"
Write-Host ""

Write-Host "8. Install ALL Basic Apps"
Write-Host ""
Write-Host "0. Back"
Write-Host ""

$choice=Read-Host "Select"

switch($choice){

"1"{Install-App "Google.Chrome" "https://dl.google.com/chrome/install/latest/chrome/install.exe" "chrome.exe"}

"2"{Install-App "Mozilla.Firefox" "https://download.mozilla.org/?product=firefox-latest&os=win&lang=en-US" "firefox.exe"}

"3"{Install-App "7zip.7zip" "https://www.7-zip.org/a/7z2301-x64.exe" "7zip.exe"}

"4"{Install-App "Adobe.Acrobat.Reader.64-bit" "https://ardownload2.adobe.com/pub/adobe/reader/win/AcrobatDC/AcroRdrDCx64.exe" "reader.exe"}

"5"{Install-App "RARLab.WinRAR" "https://www.rarlab.com/rar/winrar-x64.exe" "winrar.exe"}

"6"{Install-App "AIMP.AIMP" "https://www.aimp.ru/?do=download.file&id=2" "aimp.exe"}

"7"{Install-App "VideoLAN.VLC" "https://get.videolan.org/vlc/last/win64/vlc-win64.exe" "vlc.exe"}

"8"{

Install-App "Google.Chrome" ""
Install-App "7zip.7zip" ""
Install-App "VideoLAN.VLC" ""
Install-App "RARLab.WinRAR" ""
Install-App "AIMP.AIMP" ""

}

"0"{return}

}

PauseMenu

}

}
