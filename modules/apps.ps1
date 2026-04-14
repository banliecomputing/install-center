function Test-Winget {
    return (Get-Command winget -ErrorAction SilentlyContinue) -ne $null
}

function Show-Header {
    Clear-Host
    Write-Host "==========================================" -ForegroundColor Cyan
    Write-Host "      AUTOMATIC APPLICATION INSTALLER v.1.1    " -ForegroundColor Cyan
    Write-Host "==========================================" -ForegroundColor Cyan
    Write-Host ""
}

function PauseMenu {
    Write-Host ""
    Read-Host "Tekan Enter untuk kembali ke menu..."
}

function Install-App($wingetID, $url, $file) {
    Write-Host ""
    Write-Host "------------------------------------------" -ForegroundColor Gray
    Write-Host "Menyiapkan instalasi: $wingetID" -ForegroundColor Cyan

    if (Test-Winget) {
        Write-Host "Menggunakan Winget untuk menginstal..." -ForegroundColor Green
        winget install -e --id $wingetID --silent --accept-package-agreements --accept-source-agreements
    } else {
        if (!$url) {
            Write-Host "WinGet tidak ditemukan & URL download tidak tersedia." -ForegroundColor Red
            return
        }

        Write-Host "WinGet tidak ditemukan. Mengunduh installer secara manual..." -ForegroundColor Yellow
        $temp = "$env:TEMP\$file"
        
        try {
            Invoke-WebRequest $url -OutFile $temp -ErrorAction Stop
            Write-Host "Menjalankan installer..." -ForegroundColor Green
            # Menambahkan /S untuk instalasi silent pada installer .exe umum
            Start-Process $temp -ArgumentList "/S" -Wait
            Remove-Item $temp -ErrorAction SilentlyContinue
        } catch {
            Write-Host "Gagal mengunduh file dari $url" -ForegroundColor Red
        }
    }

    Write-Host "Selesai memproses $wingetID" -ForegroundColor Green
}

function Show-Apps {
    while ($true) {
        Show-Header
        Write-Host "DAFTAR APLIKASI:" -ForegroundColor Green
        Write-Host ""
        Write-Host "==== Browser ====" -ForegroundColor Yellow
        Write-Host "1. Install Google Chrome"
        Write-Host "2. Mozilla Firefox"
        Write-Host ""
        Write-Host "==== Tools ====" -ForegroundColor Yellow
        Write-Host "3. Install 7zip"
        Write-Host "4. Adobe Acrobat Reader"
        Write-Host "5. WinRAR"
        Write-Host ""
        Write-Host "==== Media ====" -ForegroundColor Yellow
        Write-Host "6. AIMP Player"
        Write-Host "7. Install VLC"
        Write-Host ""
        Write-Host "8. [INSTALL SEMUA APLIKASI DASAR]" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "0. Keluar"
        Write-Host ""

        $choice = Read-Host "Pilih nomor (0-8)"

        switch ($choice) {
            "1" { Install-App "Google.Chrome" "https://google.com" "chrome.exe"; PauseMenu }
            "2" { Install-App "Mozilla.Firefox" "https://mozilla.org" "firefox.exe"; PauseMenu }
            "3" { Install-App "7zip.7zip" "https://7-zip.org" "7zip.exe"; PauseMenu }
            "4" { Install-App "Adobe.Acrobat.Reader.64-bit" "https://adobe.com" "reader.exe"; PauseMenu }
            "5" { Install-App "RARLab.WinRAR" "https://rarlab.com" "winrar.exe"; PauseMenu }
            "6" { Install-App "AIMP.AIMP" "https://aimp.ru" "aimp.exe"; PauseMenu }
            "7" { Install-App "VideoLAN.VLC" "https://videolan.org" "vlc.exe"; PauseMenu }
            "8" {
                Write-Host "`nMenginstal semua aplikasi dasar..." -ForegroundColor Magentat
                Install-App "Google.Chrome" "https://google.com" "chrome.exe"
                Install-App "7zip.7zip" "https://7-zip.org" "7zip.exe"
                Install-App "VideoLAN.VLC" "https://videolan.org" "vlc.exe"
                Install-App "RARLab.WinRAR" "https://rarlab.com" "winrar.exe"
                PauseMenu
            }
            "0" { break }
            default { Write-Host "Pilihan tidak valid." -ForegroundColor Red; Start-Sleep -Seconds 1 }
        }
    }
}

# Jalankan Menu Utama
Show-Apps
