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

    # Memaksa penggunaan TLS 1.2 untuk menghindari error koneksi GitHub
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    Write-Host ""
    
    # Menyesuaikan judul jika aplikasi tidak memiliki WingetID (aplikasi custom)
    $displayName = if ($wingetID) { $wingetID } else { $file }
    Write-Host "Preparing install: $displayName" -ForegroundColor Cyan

    $installedViaWinget = $false

    # Coba gunakan Winget terlebih dahulu (HANYA JIKA WingetID BENAR-BENAR TERSEDIA)
    if((Test-Winget) -and $wingetID){
        
        # Mengecek apakah aplikasi sudah terinstall di sistem menggunakan Winget List
        Write-Host "Mengecek status instalasi via Winget..." -ForegroundColor DarkGray
        $checkInstalled = winget list -e --id $wingetID --accept-source-agreements 2>$null
        
        if ($checkInstalled -match $wingetID) {
            Write-Host "=> Aplikasi $wingetID sudah terinstall di sistem. Melewati proses." -ForegroundColor Green
            return # Langsung keluar dari fungsi dan lanjut ke aplikasi berikutnya
        }

        Write-Host "Installing using Winget..." -ForegroundColor Green
        winget install -e --id $wingetID --silent --accept-package-agreements --accept-source-agreements
        
        if ($LASTEXITCODE -eq 0) {
            $installedViaWinget = $true
        } else {
            Write-Host "Winget encountered an error. Falling back to direct download..." -ForegroundColor Yellow
        }
    }

    # Mode Unduh Manual (jika Winget tidak ada, gagal, atau aplikasi custom GitHub)
    if(-not $installedViaWinget){
        
        if(!$url){
            Write-Host "No download URL provided and Winget is unavailable." -ForegroundColor Red
            return
        }

        $temp = "$env:TEMP\$file"
        Write-Host "Downloading installer dari URL..." -ForegroundColor Yellow

        try {
            # Menyamarkan PowerShell sebagai browser untuk menghindari Error 500/403
            $userAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
            
            # Memastikan progress bar unduhan tidak disembunyikan
            $ProgressPreference = 'Continue'
            Invoke-WebRequest -Uri $url -OutFile $temp -UseBasicParsing -UserAgent $userAgent
            
            # Logika Khusus untuk Aplikasi Portable (seperti WUB)
            if ($silentArgs -eq "PORTABLE") {
                Write-Host "Menyiapkan aplikasi portable..." -ForegroundColor Yellow
                
                $appName = [System.IO.Path]::GetFileNameWithoutExtension($file)
                
                # Cek apakah user menjalankan PowerShell sebagai Administrator
                $isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
                
                # Jika Admin, taruh di Program Files. Jika tidak, taruh di LocalAppData agar tidak error
                $targetDir = if ($isAdmin) { "$env:ProgramFiles\$appName" } else { "$env:LOCALAPPDATA\Programs\$appName" }
                
                # Buat folder jika belum ada
                if (-not (Test-Path $targetDir)) { New-Item -ItemType Directory -Path $targetDir -Force | Out-Null }
                
                $targetPath = "$targetDir\$file"
                Write-Host "Menyalin file ke $targetPath..." -ForegroundColor DarkGray
                Copy-Item -Path $temp -Destination $targetPath -Force
                
                Write-Host "Membuat Shortcut di Desktop..." -ForegroundColor Yellow
                $WshShell = New-Object -ComObject WScript.Shell
                $desktopPath = [Environment]::GetFolderPath("Desktop")
                $Shortcut = $WshShell.CreateShortcut("$desktopPath\$appName.lnk")
                $Shortcut.TargetPath = $targetPath
                $Shortcut.WorkingDirectory = $targetDir
                $Shortcut.Save()

            } else {
                Write-Host "Running installer..." -ForegroundColor Green
                # Eksekusi installer secara diam-diam (silent)
                Start-Process -FilePath $temp -ArgumentList $silentArgs -Wait
            }
            
            # Hapus file mentahan agar tidak memenuhi hardisk C:
            Remove-Item -Path $temp -Force -ErrorAction SilentlyContinue
            Write-Host "Cleanup: Removed temporary file." -ForegroundColor DarkGray

        } catch {
            Write-Host "Error saat mengeksekusi unduhan: $($_.Exception.Message)" -ForegroundColor Red
            return
        }
    }

    Write-Host "Finished processing $displayName" -ForegroundColor Green
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
        [PSCustomObject]@{ Id = 7; Name = "VLC Player"; WingetID = "VideoLAN.VLC"; Url = "https://get.videolan.org/vlc/last/win64/vlc-win64.exe"; File = "vlc.exe"; Silent = "/L=1033 /S" },
        
        # --- CUSTOM HOSTED APPS (GITHUB) ---
        [PSCustomObject]@{ Id = 8; Name = "Picasa Viewer"; WingetID = ""; Url = "https://github.com/banliecomputing/install-center/releases/download/APPS/picasa39-setup.exe"; File = "picasa39-setup.exe"; Silent = "/S" },
        [PSCustomObject]@{ Id = 9; Name = "Adobe Reader 11"; WingetID = ""; Url = "https://github.com/banliecomputing/install-center/releases/download/APPS/AdbeRdr11000_en_US.exe"; File = "AdbeRdr11000_en_US.exe"; Silent = "/S" },
        [PSCustomObject]@{ Id = 10; Name = "WinRAR7 10x64"; WingetID = ""; Url = "https://github.com/banliecomputing/install-center/releases/download/APPS/WinRAR7.10x64.exe"; File = "WinRAR7.10x64.exe"; Silent = "/S" },
        
        # --- PORTABLE APPS (WUB) ---
        [PSCustomObject]@{ Id = 11; Name = "Windows Update Blocker v1.8"; WingetID = ""; Url = "https://github.com/banliecomputing/install-center/releases/download/V1.8/Wub_x64.exe"; File = "Wub_x64.exe"; Silent = "PORTABLE" }
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

        Write-Host "==== Custom Hosted Apps ====" -ForegroundColor Magenta
        Write-Host " [8] Picasa Viewer 3.9"
        Write-Host " [9] Adobe Reader 11"
        Write-Host " [10] WinRAR 7 W10-11x64"
        Write-Host " [11] Install Windows Update Blocker v1.8"
        Write-Host ""
        
        Write-Host "--------------------------------------------------------"
        Write-Host " [A] Install SEMUA Aplikasi" -ForegroundColor Green
        Write-Host " [0] Kembali ke Menu Utama" -ForegroundColor Red
        Write-Host "========================================================" -ForegroundColor Yellow

        $userInput = Read-Host "`nMasukkan pilihan Anda (Contoh: '1', '1,3,11', 'A', atau '0')"

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
