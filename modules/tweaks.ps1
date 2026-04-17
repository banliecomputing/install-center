# ========================================
# MODULE: WINDOWS TWEAKS & OPTIMIZATION
# ========================================

function Show-Tweaks {

    # Pengecekan Hak Akses Administrator
    $isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

    while ($true) {

        Show-Header

        if (-not $isAdmin) {
            Write-Host " [!] PERINGATAN: Jalankan PowerShell sebagai Administrator agar semua Tweak berhasil!" -ForegroundColor Red
            Write-Host ""
        }

        Write-Host "========== WINDOWS TWEAKS ==========" -ForegroundColor Magenta
        Write-Host ""

        Write-Host "1. Enable Dark Mode"
        Write-Host "2. Show File Extensions"
        Write-Host "3. Disable Windows Telemetry (Butuh Admin)"
        Write-Host "4. Disable Startup Delay"
        Write-Host "5. Disable Windows Tips"
        Write-Host ""
        Write-Host "===== PERFORMANCE =====" -ForegroundColor Yellow
        Write-Host "6. Enable Ultimate Performance"
        Write-Host "7. Disable Background Apps"
        Write-Host ""
        Write-Host "===== EXPLORER =====" -ForegroundColor Yellow
        Write-Host "8. Show Hidden Files"
        Write-Host "9. Disable Shortcut Arrow (Butuh Admin)"
        Write-Host "10. Clear Recent Files & Explorer History"
        Write-Host ""
        Write-Host "0. Back"
        Write-Host ""

        $choice = Read-Host "Select"

        switch ($choice) {

            "1" {
                Show-Header
                Write-Host "Enabling Dark Mode..." -ForegroundColor Yellow
                Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name AppsUseLightTheme -Value 0
                Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name SystemUsesLightTheme -Value 0
                Write-Host "Dark Mode Enabled" -ForegroundColor Green
                PauseMenu
            }

            "2" {
                Show-Header
                Write-Host "Enabling File Extensions..." -ForegroundColor Yellow
                Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name HideFileExt -Value 0
                Write-Host "File Extensions Enabled" -ForegroundColor Green
                PauseMenu
            }

            "3" {
                Show-Header
                Write-Host "Disabling Telemetry..." -ForegroundColor Yellow
                try {
                    $path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
                    if (-not (Test-Path $path)) { New-Item -Path $path -Force | Out-Null }
                    New-ItemProperty -Path $path -Name "AllowTelemetry" -PropertyType DWord -Value 0 -Force | Out-Null
                    Write-Host "Telemetry Disabled" -ForegroundColor Green
                } catch {
                    Write-Host "Gagal. Pastikan Anda menjalankan ini sebagai Administrator." -ForegroundColor Red
                }
                PauseMenu
            }

            "4" {
                Show-Header
                Write-Host "Disabling Startup Delay..." -ForegroundColor Yellow
                # Seringkali folder Serialize tidak ada, harus dibuat dulu
                $path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize"
                if (-not (Test-Path $path)) { New-Item -Path $path -Force | Out-Null }
                Set-ItemProperty -Path $path -Name "StartupDelayInMSec" -Value 0 -Force
                Write-Host "Startup Delay Disabled" -ForegroundColor Green
                PauseMenu
            }

            "5" {
                Show-Header
                Write-Host "Disabling Windows Tips..." -ForegroundColor Yellow
                Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name SubscribedContent-338389Enabled -Value 0
                Write-Host "Windows Tips Disabled" -ForegroundColor Green
                PauseMenu
            }

            "6" {
                Show-Header
                Write-Host "Enabling Ultimate Performance..." -ForegroundColor Yellow
                powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 | Out-Null
                Write-Host "Ultimate Performance Enabled" -ForegroundColor Green
                PauseMenu
            }

            "7" {
                Show-Header
                Write-Host "Disabling Background Apps..." -ForegroundColor Yellow
                Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" -Name GlobalUserDisabled -Value 1
                Write-Host "Background Apps Disabled" -ForegroundColor Green
                PauseMenu
            }

            "8" {
                Show-Header
                Write-Host "Enabling Hidden Files..." -ForegroundColor Yellow
                Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name Hidden -Value 1
                Write-Host "Hidden Files Enabled" -ForegroundColor Green
                PauseMenu
            }

            "9" {
                Show-Header
                Write-Host "Removing Shortcut Arrows..." -ForegroundColor Yellow
                try {
                    $path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons"
                    if (-not (Test-Path $path)) { New-Item -Path $path -Force | Out-Null }
                    New-ItemProperty -Path $path -Name "29" -Value "" -PropertyType String -Force | Out-Null
                    
                    Write-Host "Restarting Windows Explorer..." -ForegroundColor Yellow
                    Stop-Process -Name explorer -Force
                    Start-Sleep -Seconds 1
                    Start-Process explorer
                    Write-Host "Shortcut Arrow Removed" -ForegroundColor Green
                } catch {
                    Write-Host "Gagal. Pastikan Anda menjalankan ini sebagai Administrator." -ForegroundColor Red
                }
                PauseMenu
            }

            "10" {
                Show-Header
                Write-Host "Clearing Recent Files & Explorer History..." -ForegroundColor Yellow
                
                # Menghapus file Recent Docs
                Remove-Item -Path "$env:APPDATA\Microsoft\Windows\Recent\*" -Force -Recurse -ErrorAction SilentlyContinue
                
                # Menghapus Quick Access / Automatic Destinations
                Remove-Item -Path "$env:APPDATA\Microsoft\Windows\Recent\AutomaticDestinations\*" -Force -Recurse -ErrorAction SilentlyContinue
                Remove-Item -Path "$env:APPDATA\Microsoft\Windows\Recent\CustomDestinations\*" -Force -Recurse -ErrorAction SilentlyContinue
                
                # Menghapus riwayat Run Dialog
                Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU" -Name "*" -ErrorAction SilentlyContinue
                
                # Menghapus Typed Paths (Path folder yang diketik di URL bar File Explorer)
                Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\TypedPaths" -Name "url*" -ErrorAction SilentlyContinue
                
                Write-Host "History dan Cache Explorer berhasil dihapus!" -ForegroundColor Green
                PauseMenu
            }

            "0" { return }

            default {
                Write-Host "Invalid choice" -ForegroundColor Red
                Start-Sleep 1
            }
        }
    }
}
