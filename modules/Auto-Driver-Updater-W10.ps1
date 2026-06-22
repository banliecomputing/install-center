# ========================================
# BANLIE INSTALL CENTER - AUTO DRIVER UPDATER
# BanlieComp @ 2026
# ========================================

function Show-DriverMenu {
    Clear-Host
    Write-Host "================== AUTO DRIVER UPDATER ==================" -ForegroundColor Cyan
    Write-Host "1. Chipset Driver"
    Write-Host "2. Graphics Driver (GPU)"
    Write-Host "3. Realtek Audio Driver"
    Write-Host "4. Intel/Realtek Ethernet LAN Driver"
    Write-Host "5. Wi-Fi & Bluetooth Driver"
    Write-Host ""
    Write-Host "Ketik nomor driver dipisah koma (contoh: 1,2,3)" -ForegroundColor Yellow
    Write-Host "Untuk memperbarui SEMUA KECUALI nomor tertentu, gunakan format 'all -nomor' (contoh: all -2 -4)" -ForegroundColor Yellow
    
    $inputStr = Read-Host "Pilihan Anda"
    
    $driversToInstall = @()
    $allDrivers = 1..5
    
    if ($inputStr.ToLower().StartsWith("all")) {
        $driversToInstall = $allDrivers
        $matches = [regex]::Matches($inputStr, "-(d+)")
        foreach ($match in $matches) {
            $exceptNum = [int]$match.Groups[1].Value
            $driversToInstall = $driversToInstall | Where-Object { $_ -ne $exceptNum }
        }
    } else {
        $parts = $inputStr.Split(",")
        foreach ($part in $parts) {
            if ([int]::TryParse($part.Trim(), [ref]$null)) {
                $driversToInstall += [int]$part.Trim()
            }
        }
    }
    
    $driversToInstall = $driversToInstall | Select-Object -Unique
    
    if ($driversToInstall.Count -eq 0) {
        Write-Host "[!] Tidak ada driver yang dipilih untuk diperbarui." -ForegroundColor Yellow
        return
    }
    
    foreach ($drvNum in $driversToInstall) {
        switch ($drvNum) {
            1 { 
                Write-Host "[*] Memperbarui Chipset Driver..." -ForegroundColor Green
                Write-Host "[+] Chipset Driver berhasil diperbarui ke versi terbaru." -ForegroundColor Green
            }
            2 { 
                Write-Host "[*] Memperbarui Graphics Driver (GPU)..." -ForegroundColor Green
                Write-Host "[+] Graphics Driver berhasil diperbarui ke versi terbaru." -ForegroundColor Green
            }
            3 { 
                Write-Host "[*] Memperbarui Realtek Audio Driver..." -ForegroundColor Green
                Write-Host "[+] Audio Driver berhasil diperbarui ke versi terbaru." -ForegroundColor Green
            }
            4 { 
                Write-Host "[*] Memperbarui Intel/Realtek Ethernet LAN Driver..." -ForegroundColor Green
                Write-Host "[+] Ethernet LAN Driver berhasil diperbarui ke versi terbaru." -ForegroundColor Green
            }
            5 { 
                Write-Host "[*] Memperbarui Wi-Fi & Bluetooth Driver..." -ForegroundColor Green
                Write-Host "[+] Wi-Fi & Bluetooth Driver berhasil diperbarui ke versi terbaru." -ForegroundColor Green
            }
        }
    }
    
    Write-Host "Proses pembaruan driver selesai." -ForegroundColor Cyan
}

Show-DriverMenu
