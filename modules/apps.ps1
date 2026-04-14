function Install-App($wingetID, $url, $file, $silentArgs="/S"){

    Write-Host ""
    Write-Host "Preparing install: $wingetID" -ForegroundColor Cyan

    $installedViaWinget = $false

    # Langkah 1: Coba gunakan Winget terlebih dahulu
    if(Test-Winget){
        Write-Host "Installing using Winget..." -ForegroundColor Green
        winget install -e --id $wingetID --silent --accept-package-agreements --accept-source-agreements
        
        # Cek apakah Winget berhasil (Exit Code 0)
        if ($LASTEXITCODE -eq 0) {
            $installedViaWinget = $true
        } else {
            Write-Host "Winget encountered an error. Falling back to direct download..." -ForegroundColor Yellow
        }
    }

    # Langkah 2: Mode Unduh Manual (jika Winget tidak ada atau gagal)
    if(-not $installedViaWinget){
        
        if(!$url){
            Write-Host "No download URL provided and Winget is unavailable/failed." -ForegroundColor Red
            return
        }

        if (-not (Test-Winget)) {
            Write-Host "Winget not found. Downloading installer..." -ForegroundColor Yellow
        }

        $temp = "$env:TEMP\$file"

        try {
            # Mengunduh file installer
            Invoke-WebRequest -Uri $url -OutFile $temp -UseBasicParsing
            
            Write-Host "Running installer..." -ForegroundColor Green
            # Menjalankan installer dengan parameter senyap
            Start-Process -FilePath $temp -ArgumentList $silentArgs -Wait
            
            # Pembersihan file temp setelah instalasi
            Remove-Item -Path $temp -Force -ErrorAction SilentlyContinue
            Write-Host "Cleanup: Removed temporary installer." -ForegroundColor DarkGray

        } catch {
            Write-Host "Error during download or execution: $($_.Exception.Message)" -ForegroundColor Red
            return
        }
    }

    Write-Host "Finished processing $wingetID" -ForegroundColor Green
}

function Show-Apps {

    while ($true) {

        Show-Header

        Write-Host "APPLICATION INSTALLER" -ForegroundColor Green
        Write-Host ""

        Write-Host "==== Browser Windows ====" -ForegroundColor Yellow
        Write-Host "1. Install Google Chrome"
        Write-Host "2. Install Mozilla Firefox"
        Write-Host ""

        Write-Host "==== Tools ====" -ForegroundColor Yellow
        Write-Host "3. Install 7zip"
        Write-Host "4. Install Acrobat Reader"
        Write-Host "5. Install WinRAR"
        Write-Host ""

        Write-Host "==== Media Viewer ====" -ForegroundColor Yellow
        Write-Host "6. Install Aimp Player"
        Write-Host "7. Install VLC Player"
        Write-Host ""

        Write-Host "8. Install ALL Basic Apps"
        Write-Host ""
        Write-Host "0. Back"
        Write-Host ""

        $choice = Read-Host "Select"

        switch ($choice) {

            "1" {
                Install-App "Google.Chrome" "https://dl.google.com/chrome/install/latest/chrome/install.exe" "chrome.exe" "--silent"
                PauseMenu
            }

            "2" {
                Install-App "Mozilla.Firefox" "https://download.mozilla.org/?product=firefox-latest&os=win&lang=en-US" "firefox.exe" "/S"
                PauseMenu
            }

            "3" {
                Install-App "7zip.7zip" "https://www.7-zip.org/a/7z2301-x64.exe" "7zip.exe" "/S"
                PauseMenu
            }

            "4" {
                Install-App "Adobe.Acrobat.Reader.64-bit" "https://ardownload2.adobe.com/pub/adobe/reader/win/AcrobatDC/AcroRdrDCx64.exe" "reader.exe" "/sAll"
                PauseMenu
            }

            "5" {
                Install-App "RARLab.WinRAR" "https://www.rarlab.com/rar/winrar-x64.exe" "winrar.exe" "/S"
                PauseMenu
            }

            "6" {
                Install-App "AIMP.AIMP" "https://www.aimp.ru/?do=download.file&id=2" "aimp.exe" "/AUTO"
                PauseMenu
            }

            "7" {
                Install-App "VideoLAN.VLC" "https://get.videolan.org/vlc/last/win64/vlc-win64.exe" "vlc.exe" "/L=1033 /S"
                PauseMenu
            }

            "8" {
                Write-Host ""
                Write-Host "Installing ALL Basic Apps..." -ForegroundColor Cyan

                Install-App "Google.Chrome" "https://dl.google.com/chrome/install/latest/chrome/install.exe" "chrome.exe" "--silent"
                Install-App "7zip.7zip" "https://www.7-zip.org/a/7z2301-x64.exe" "7zip.exe" "/S"
                Install-App "VideoLAN.VLC" "https://get.videolan.org/vlc/last/win64/vlc-win64.exe" "vlc.exe" "/L=1033 /S"
                Install-App "RARLab.WinRAR" "https://www.rarlab.com/rar/winrar-x64.exe" "winrar.exe" "/S"
                Install-App "AIMP.AIMP" "https://www.aimp.ru/?do=download.file&id=2" "aimp.exe" "/AUTO"

                PauseMenu
            }

            "0" { return }

        }
    }
}
