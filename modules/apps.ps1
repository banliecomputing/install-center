# ========================================
# BANLIE INSTALL CENTER - APPLICATIONS
# BanlieComp @ 2026
# ========================================

function Show-Apps {
    Clear-Host
    Write-Host "================== INSTALL APLIKASI ==================" -ForegroundColor Cyan
    Write-Host "1. Google Chrome"
    Write-Host "2. 7-Zip"
    Write-Host "3. Git"
    Write-Host "4. VLC Media Player"
    Write-Host "5. Visual Studio Code"
    Write-Host ""
    Write-Host "Ketik nomor aplikasi dipisah koma (contoh: 1,2,3)" -ForegroundColor Yellow
    Write-Host "Untuk menginstal SEMUA KECUALI nomor tertentu, gunakan format 'all -nomor' (contoh: all -2 -5)" -ForegroundColor Yellow
    
    $inputStr = Read-Host "Pilihan Anda"
    
    $appsToInstall = @()
    $allApps = 1..5
    
    if ($inputStr.ToLower().StartsWith("all")) {
        $appsToInstall = $allApps
        $matches = [regex]::Matches($inputStr, "-(d+)")
        foreach ($match in $matches) {
            $exceptNum = [int]$match.Groups[1].Value
            $appsToInstall = $appsToInstall | Where-Object { $_ -ne $exceptNum }
        }
    } else {
        $parts = $inputStr.Split(",")
        foreach ($part in $parts) {
            if ([int]::TryParse($part.Trim(), [ref]$null)) {
                $appsToInstall += [int]$part.Trim()
            }
        }
    }
    
    $appsToInstall = $appsToInstall | Select-Object -Unique
    
    foreach ($appNum in $appsToInstall) {
        switch ($appNum) {
            1 { Write-Host "Menginstal Google Chrome..." -ForegroundColor Green; winget install --id Google.Chrome -e --silent }
            2 { Write-Host "Menginstal 7-Zip..." -ForegroundColor Green; winget install --id 7zip.7zip -e --silent }
            3 { Write-Host "Menginstal Git..." -ForegroundColor Green; winget install --id Git.Git -e --silent }
            4 { Write-Host "Menginstal VLC Media Player..." -ForegroundColor Green; winget install --id VideoLAN.VLC -e --silent }
            5 { Write-Host "Menginstal Visual Studio Code..." -ForegroundColor Green; winget install --id Microsoft.VisualStudioCode -e --silent }
        }
    }
    
    Write-Host "Instalasi selesai." -ForegroundColor Cyan
}

Show-Apps
