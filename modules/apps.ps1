# ========================================
# MODULE: APPLICATION INSTALLER
# ========================================

# Fungsi untuk menginstal Winget secara paksa jika tidak ada di PC target
function Install-WingetForce {
    Write-Host ""
    Write-Host "Winget tidak terdeteksi di sistem ini!" -ForegroundColor Red
    Write-Host "Memulai instalasi Winget secara otomatis..." -ForegroundColor Cyan

    $progressPreference = 'SilentlyContinue'
    $wingetUrl = "https://github.com/microsoft/winget-cli/releases/latest/download/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
    $tempPath = "$env:TEMP\winget.msixbundle"

    try {
        Write-Host "Mengunduh paket Winget (DesktopAppInstaller)..." -ForegroundColor Yellow
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        
        Invoke-WebRequest -Uri $wingetUrl -OutFile $tempPath -UseBasicParsing
        
        Write-Host "Memasang Winget ke dalam sistem..." -ForegroundColor Yellow
        Add-AppxPackage -Path $tempPath
        
        Write-Host "Winget berhasil diinstal!" -ForegroundColor Green
        Remove-Item -Path $tempPath -Force -ErrorAction SilentlyContinue

    } catch {
        Write-Host "Gagal menginstal Winget secara otomatis: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host "Sistem akan beralih ke mode unduh manual (Direct Link)." -ForegroundColor DarkGray
    }
}

# Fungsi utama untuk menginstal aplikasi (Gabungan Winget + Fallback Direct Download)
function Install-App($wingetID, $url, $file, $silentArgs="/S"){

    Write-Host ""
    Write-Host "Preparing install: $wingetID" -ForegroundColor Cyan

    $installedViaWinget = $false

    # Coba gunakan Winget terlebih dahulu
    if(Test-Winget){
        Write-Host "Installing using Winget..." -ForegroundColor Green
        winget install -e --id $wingetID --silent --accept-package-agreements --accept-source-agreements
        
        if ($LASTEXITCODE -eq 0) {
            $installedViaWinget = $true
        } else {
            Write-Host "Winget encountered an error. Falling back to direct download..." -ForegroundColor Yellow
        }
    }

    # Mode Unduh Manual (jika Winget tidak ada atau gagal karena jaringan/error)
    if(-not $installedViaWinget){
        
        if(!$url){
            Write-Host "No download URL provided and Winget is unavailable." -ForegroundColor Red
            return
        }

        $temp = "$env:TEMP\$file"
        Write-Host "Downloading installer..." -ForegroundColor Yellow

        try {
            # Menyamarkan PowerShell sebagai browser untuk menghindari Error 500/403
            $userAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
            
            Invoke-WebRequest -Uri $url -OutFile $temp -UseBasicParsing -UserAgent $userAgent
            
            Write-Host "Running installer..." -ForegroundColor Green
            # Eksekusi installer secara diam-diam (silent)
            Start-Process -FilePath $temp -ArgumentList $silentArgs -Wait
            
            # Hapus file mentahan agar tidak memenuhi hardisk C:
            Remove-Item -Path $temp -Force -ErrorAction SilentlyContinue
            Write-Host "Cleanup: Removed temporary file." -ForegroundColor DarkGray

        } catch {
            Write-Host "Download Error: $($_.Exception.Message)" -ForegroundColor Red
            Write-Host "Catatan: Jika masih error 404, link URL sudah mati/diganti oleh vendor." -ForegroundColor DarkGray
            return
        }
    }

    Write-Host "Finished processing $wingetID" -ForegroundColor Green
}

# Menu Aplikasi dengan fitur Multiple Selection
function Show-Apps {

    # Pengecekan awal, jika tidak ada winget, paksa install
    if (-not (Test-Winget)) {
        Install-WingetForce
        Start-Sleep -Seconds 3 
    }

    # Database Aplikasi
    $appList = @(
        [PSCustomObject]@{ Id = 1; Name = "Google Chrome"; WingetID = "Google.Chrome"; Url = "https://dl.google.com/chrome/install/latest/chrome/install.exe"; File = "chrome.exe"; Silent = "--silent" },
        [PSCustomObject]@{ Id = 2; Name = "Mozilla Firefox"; WingetID = "Mozilla.Firefox"; Url = "https://download.mozilla.org/?product=firefox-latest&os=win64&lang=en-US"; File = "firefox.exe"; Silent = "/S" },
        [PSCustomObject]@{ Id = 3; Name = "7zip"; WingetID = "7zip.7zip"; Url = "https://www.7-zip.org/a/7z2301-x64.exe"; File = "7zip.exe"; Silent = "/S" },
        [PSCustomObject]@{ Id = 4; Name = "Acrobat Reader"; WingetID = "Adobe.Acrobat.Reader.64-bit"; Url = "https://ardownload2.adobe.com/pub/adobe/reader/win/AcrobatDC/AcroRdrDCx64.exe"; File = "reader.exe"; Silent = "/sAll" },
        [PSCustomObject]@{ Id = 5; Name = "WinRAR"; WingetID = "RARLab.WinRAR"; Url = "https://www.rarlab.com/rar/winrar-x64.exe"; File = "winrar.exe"; Silent = "/S" },
        [PSCustomObject]@{ Id = 6; Name = "Aimp Player"; WingetID = "AIMP.AIMP"; Url = "https://www.aimp.ru/?do=download.file&id=2"; File = "aimp.exe"; Silent = "/AUTO" },
        [PSCustomObject]@{ Id = 7; Name = "VLC Player"; WingetID = "VideoLAN.VLC"; Url = "https://get.videolan.org/vlc/last/win64/vlc-win64.exe"; File = "vlc.exe"; Silent = "/L=1033 /S" }
    )

    while ($true) {

        Show-Header

        Write-Host "APPLICATION INSTALLER" -ForegroundColor Green
        Write-Host ""

        Write-Host "==== Browser Windows ====" -ForegroundColor Yellow
        Write-Host " [1] Install Google Chrome"
        Write-Host " [2] Install Mozilla Firefox"
        Write-Host ""

        Write-Host "==== Tools ====" -ForegroundColor Yellow
        Write-Host " [3] Install 7zip"
        Write-Host " [4] Install Acrobat Reader"
        Write-Host " [5] Install WinRAR"
        Write-Host ""

        Write-Host "==== Media Viewer ====" -ForegroundColor Yellow
        Write-Host " [6] Install Aimp Player"
        Write-Host " [7] Install VLC Player"
        Write-Host ""
        
        Write-Host "--------------------------------------------------------"
        Write-Host " [A] Install SEMUA Aplikasi" -ForegroundColor Green
        Write-Host " [0] Kembali ke Menu Utama" -ForegroundColor Red
        Write-Host "========================================================" -ForegroundColor Yellow

        $userInput = Read-Host "`nMasukkan pilihan Anda (Contoh: '1', '1,3,4', 'A', atau '0')"

        if ($userInput -eq '0') { return }

        $selectedApps = New-Object System.Collections.ArrayList

        # Parsing Input User
        if ($userInput -match '^[aA]$') {
            # Pilih semua aplikasi
            foreach ($app in $appList) {
                $null = $selectedApps.Add($app)
            }
        } else {
            # Pilih spesifik berdasarkan angka koma
            $selections = $userInput -split ','
            foreach ($sel in $selections) {
                $index = 0
                if ([int]::TryParse($sel.Trim(), [ref]$index)) {
                    # Cari aplikasi berdasarkan ID
                    $foundApp = $appList | Where-Object { $_.Id -eq $index }
                    
                    if ($foundApp) {
                        $null = $selectedApps.Add($foundApp)
                    } else {
                        Write-Host "Nomor [$index] tidak valid dan akan dilewati." -ForegroundColor Red
                    }
                }
            }
        }

        # Eksekusi Instalasi
        if ($selectedApps.Count -gt 0) {
            Write-Host "`nMempersiapkan instalasi untuk $($selectedApps.Count) aplikasi..." -ForegroundColor Cyan
            
            foreach ($app in $selectedApps) {
                Install-App -wingetID $app.WingetID -url $app.Url -file $app.File -silentArgs $app.Silent
            }
            
            Write-Host "`nSemua proses instalasi yang dipilih telah selesai!" -ForegroundColor Green
            PauseMenu
        } else {
            Write-Host "Tidak ada aplikasi valid yang dipilih. Silakan coba lagi." -ForegroundColor Red
            Start-Sleep -Seconds 2
        }
    }
}
