function Install-App($wingetID,$manualURL,$filename){

$winget = Get-Command winget -ErrorAction SilentlyContinue

if($winget){

```
Write-Host "Installing using Winget..." -ForegroundColor Cyan
winget install -e --id $wingetID --silent
```

}else{

```
Write-Host "Winget not found. Downloading manual installer..." -ForegroundColor Yellow

$temp="$env:TEMP\$filename"

Invoke-WebRequest $manualURL -OutFile $temp

Start-Process $temp -Wait
```

}

}

function Show-Apps {

```
while ($true) {

    Clear-Host
    Write-Host "==== APPLICATIONS ====" -ForegroundColor Green

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

    Write-Host "0. Back"
    Write-Host ""

    $choice = Read-Host "Select"

    switch ($choice) {

        "1" {

            Install-App `
            "Google.Chrome" `
            "https://dl.google.com/chrome/install/latest/chrome/install.exe" `
            "chrome.exe"

            Pause
        }

        "2" {

            Install-App `
            "Mozilla.Firefox" `
            "https://download.mozilla.org/?product=firefox-latest&os=win&lang=en-US" `
            "firefox.exe"

            Pause
        }

        "3" {

            Install-App `
            "7zip.7zip" `
            "https://www.7-zip.org/a/7z2301-x64.exe" `
            "7zip.exe"

            Pause
        }

        "4" {

            Install-App `
            "Adobe.Acrobat.Reader.64-bit" `
            "https://ardownload2.adobe.com/pub/adobe/reader/win/AcrobatDC/2300620360/AcroRdrDCx64.exe" `
            "acrobat.exe"

            Pause
        }

        "5" {

            Install-App `
            "RARLab.WinRAR" `
            "https://www.rarlab.com/rar/winrar-x64.exe" `
            "winrar.exe"

            Pause
        }

        "6" {

            Install-App `
            "AIMP.AIMP" `
            "https://www.aimp.ru/?do=download.file&id=2" `
            "aimp.exe"

            Pause
        }

        "7" {

            Install-App `
            "VideoLAN.VLC" `
            "https://get.videolan.org/vlc/last/win64/vlc-win64.exe" `
            "vlc.exe"

            Pause
        }

        "0" { return }

    }

}
```

}
