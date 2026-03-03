function Install-Chrome {
    Write-Log "Install Chrome"
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        winget install Google.Chrome -e --accept-package-agreements --accept-source-agreements
    } else {
        $url = "https://dl.google.com/chrome/install/latest/chrome_installer.exe"
        $file = "$env:TEMP\chrome.exe"
        Invoke-WebRequest $url -OutFile $file
        Start-Process $file -ArgumentList "/silent /install" -Wait
    }
}

function Install-VLC {
    Write-Log "Install VLC"
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        winget install VideoLAN.VLC -e
    } else {
        $url = "https://get.videolan.org/vlc/last/win64/vlc-setup.exe"
        $file = "$env:TEMP\vlc.exe"
        Invoke-WebRequest $url -OutFile $file
        Start-Process $file -ArgumentList "/S" -Wait
    }
}

function Menu-Install {
    Clear-Host
    Write-Host "=== INSTALL APLIKASI ==="
    Write-Host "1. Google Chrome"
    Write-Host "2. VLC"
    Write-Host "3. Install Semua"
    Write-Host "0. Kembali"
    $c = Read-Host "Pilih"

    switch ($c) {
        "1" { Install-Chrome }
        "2" { Install-VLC }
        "3" { Install-Chrome; Install-VLC }
    }
}
