# ========================================
# BANLIE INSTALL CENTER v5
# BanlieComp @ 2026
# ========================================

$base = "https://raw.githubusercontent.com/banliecomputing/install-center/main/modules"

# ================= UI =================

function Show-Header {

    Clear-Host

    Write-Host ""
    Write-Host "██████╗  █████╗ ███╗   ██╗██╗     ██╗███████╗" -ForegroundColor Cyan
    Write-Host "██╔══██╗██╔══██╗████╗  ██║██║     ██║██╔════╝" -ForegroundColor Cyan
    Write-Host "██████╔╝███████║██╔██╗ ██║██║     ██║█████╗  " -ForegroundColor Cyan
    Write-Host "██╔══██╗██╔══██║██║╚██╗██║██║     ██║██╔══╝  " -ForegroundColor Cyan
    Write-Host "██████╔╝██║  ██║██║ ╚████║███████╗██║███████╗" -ForegroundColor Cyan
    Write-Host "╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚═╝╚══════╝" -ForegroundColor Cyan

    Write-Host ""
    Write-Host "BanlieComp @ $(Get-Date -Format 'yyyy')" -ForegroundColor Yellow
    Write-Host ""

    try {
        $cpu=(Get-WmiObject Win32_Processor).Name
        $ram=[math]::Round((Get-WmiObject Win32_ComputerSystem).TotalPhysicalMemory/1GB,2)
        $os=(Get-WmiObject Win32_OperatingSystem).Caption
        $time=Get-Date -Format "dd MMM yyyy HH:mm:ss"

        Write-Host "OS   : $os"
        Write-Host "CPU  : $cpu"
        Write-Host "RAM  : $ram GB"
        Write-Host "TIME : $time"
    } catch {}

    Write-Host ""
    Write-Host "===================================" -ForegroundColor DarkGray
    Write-Host ""
}

function PauseMenu {
    Write-Host ""
    Read-Host "Press ENTER to continue"
}

# ================= WINGET CHECK =================

function Test-Winget {
    $winget = Get-Command winget -ErrorAction SilentlyContinue
    if($winget){ return $true } else { return $false }
}

# ================= MODULE LOADER =================

try{
    # Memaksa penggunaan TLS 1.2
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    $modules=@(
        "windows-tools.ps1",
        "apps.ps1",
        "tweaks.ps1",
        "online-scripts.ps1",
        "diagnostic.ps1",
        "Auto-Driver-Updater-W10.ps1" # Pastikan nama ini sesuai dengan yang ada di GitHub folder modules Anda
    )

    foreach($m in $modules){
        # Memuat modul dari GitHub dengan BYPASS CACHE
        irm "$base/$m?t=$([guid]::NewGuid())" | iex
    }
} catch {
    Write-Host ""
    Write-Host "[!] MODULE LOAD FAILED PADA FILE: $m" -ForegroundColor Red
    Write-Host "Alasan Error: $($_.Exception.Message)" -ForegroundColor DarkGray
    Write-Host "Solusi: Pastikan file '$m' benar-benar ada di GitHub dan huruf besar/kecilnya sama persis!" -ForegroundColor Yellow
    PauseMenu
    return
}

# ================= MAIN MENU =================

function Show-MainMenu {

    while($true){

        Show-Header

        Write-Host "MAIN MENU"
        Write-Host ""

        Write-Host "1. Windows Tools"
        Write-Host "2. Applications Installer"
        Write-Host "3. Tweaks & Optimization"
        Write-Host "4. Online Scripts"
        Write-Host "5. Hardware Diagnostic"
        Write-Host "6. Auto Driver Updater"
        Write-Host ""
        Write-Host "0. Exit"
        Write-Host ""

        $choice=Read-Host "Select"

        switch($choice){
            "1"{ try { Show-WindowsTools } catch { Write-Host "Modul belum tersedia." -ForegroundColor Red; PauseMenu } }
            "2"{ try { Show-Apps } catch { Write-Host "Modul belum tersedia." -ForegroundColor Red; PauseMenu } }
            "3"{ try { Show-Tweaks } catch { Write-Host "Modul belum tersedia." -ForegroundColor Red; PauseMenu } }
            "4"{ try { Show-OnlineScripts } catch { Write-Host "Modul belum tersedia." -ForegroundColor Red; PauseMenu } }
            "5"{ try { Show-Diagnostic } catch { Write-Host "Modul belum tersedia." -ForegroundColor Red; PauseMenu } }
            "6"{ try { Show-DriverUpdater } catch { Write-Host "Modul belum tersedia." -ForegroundColor Red; PauseMenu } }
            "0"{ return }
        }
    }
}

# Menjalankan program utama
Show-MainMenu
