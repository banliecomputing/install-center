# ========================================
# MODULE: WINDOWS TOOLS
# ========================================

function Show-WindowsTools {

    $isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

    while ($true) {

        Show-Header

        if (-not $isAdmin) {
            Write-Host " [!] PERINGATAN: Beberapa alat (SFC, DISM, Chkdsk) butuh akses Administrator!" -ForegroundColor Red
            Write-Host ""
        }

        Write-Host "========== WINDOWS TOOLS ==========" -ForegroundColor Yellow
        Write-Host ""

        Write-Host "1. System Information"
        Write-Host "2. Disk Cleanup"
        Write-Host "3. Check Disk (C:)"
        Write-Host "4. SFC Scan (System File Checker)"
        Write-Host "5. DISM Repair"
        Write-Host ""
        Write-Host "===== UTILITIES =====" -ForegroundColor Cyan
        Write-Host "6. Keyboard Tester Portable"
        Write-Host "7. Auto Driver Updater (Windows 10/11)"
        Write-Host ""
        Write-Host "===== NETWORK =====" -ForegroundColor Cyan
        Write-Host "8. Flush DNS"
        Write-Host "9. Network Reset"
        Write-Host ""
        Write-Host "0. Back"
        Write-Host ""

        $choice = Read-Host "Select"

        switch ($choice) {

            "1" {
                Show-Header
                Write-Host "SYSTEM INFORMATION" -ForegroundColor Green
                Write-Host ""
                systeminfo
                PauseMenu
            }

            "2" {
                Show-Header
                Write-Host "Opening Disk Cleanup..." -ForegroundColor Green
                Write-Host ""
                Start-Process cleanmgr
                PauseMenu
            }

            "3" {
                Show-Header
                Write-Host "Checking Disk C:" -ForegroundColor Green
                Write-Host ""
                if ($isAdmin) {
                    chkdsk C:
                } else {
                    Write-Host "Gagal: Harap buka Install Center sebagai Administrator." -ForegroundColor Red
                }
                PauseMenu
            }

            "4" {
                Show-Header
                Write-Host "Running System File Checker (SFC)..." -ForegroundColor Green
                Write-Host ""
                if ($isAdmin) {
                    sfc /scannow
                } else {
                    Write-Host "Gagal: Harap buka Install Center sebagai Administrator." -ForegroundColor Red
                }
                PauseMenu
            }

            "5" {
                Show-Header
                Write-Host "Running DISM Repair..." -ForegroundColor Green
                Write-Host ""
                if ($isAdmin) {
                    DISM /Online /Cleanup-Image /RestoreHealth
                } else {
                    Write-Host "Gagal: Harap buka Install Center sebagai Administrator." -ForegroundColor Red
                }
                PauseMenu
            }

            "6" {
                Show-Header
                Write-Host "KEYBOARD TESTER PORTABLE" -ForegroundColor Cyan
                Write-Host ""
                
                $url = "https://github.com/banliecomputing/install-center/releases/download/v1.0/Keyboard.Test.Portable.exe"
                $path = "$env:TEMP\keyboardtester.exe"

                try {
                    if (-not (Test-Path $path)) {
                        Write-Host "Downloading Keyboard Tester..." -ForegroundColor Yellow
                        Invoke-WebRequest -Uri $url -OutFile $path -UseBasicParsing
                    }
                    Write-Host "Launching Keyboard Tester..." -ForegroundColor Green
                    Start-Process $path
                } catch {
                    Write-Host "Gagal mengunduh. Periksa koneksi atau URL file." -ForegroundColor Red
                }
                PauseMenu
            }

            "7" {
                # Cukup panggil fungsinya karena modul sudah dimuat di install-center.ps1
                try {
                    Show-DriverUpdater
                } catch {
                    Write-Host "Failed to run Driver Updater. Modul tidak ditemukan." -ForegroundColor Red
                    PauseMenu
                }
            }

            "8" {
                Show-Header
                Write-Host "Flushing DNS..." -ForegroundColor Green
                ipconfig /flushdns
                PauseMenu
            }

            "9" {
                Show-Header
                Write-Host "Resetting Network..." -ForegroundColor Yellow
                Write-Host ""
                
                if ($isAdmin) {
                    netsh winsock reset
                    netsh int ip reset
                    ipconfig /flushdns
                    Write-Host ""
                    Write-Host "Network Reset Completed. Komputer mungkin perlu di-restart." -ForegroundColor Green
                } else {
                    Write-Host "Gagal: Harap buka Install Center sebagai Administrator." -ForegroundColor Red
                }
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
