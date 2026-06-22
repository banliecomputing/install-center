# ========================================
# BANLIE INSTALL CENTER - ARAI (Auto Run After Installer)
# BanlieComp @ 2026
# ========================================

function Show-ARAI {
    Write-Host "================== ARAI MODULE ==================" -ForegroundColor Cyan
    Write-Host "Menjalankan Instalasi dan Tweak Otomatis..." -ForegroundColor Yellow
    Write-Host ""

    # Install Default Windows Apps (Example Winget)
    Write-Host "[*] Menginstall aplikasi default windows..." -ForegroundColor Cyan
    # winget install --id Google.Chrome -e --silent --accept-package-agreements --accept-source-agreements
    # winget install --id VideoLAN.VLC -e --silent --accept-package-agreements --accept-source-agreements
    
    # Placeholder for Driver Install
    Write-Host "[*] Menyiapkan pembaruan driver otomatis..." -ForegroundColor Cyan
    # Invoke-Command or call driver updater script
    
    # Tweaks: Delete Recent Files
    Write-Host "[*] Membersihkan Recent Files..." -ForegroundColor Cyan
    Remove-Item -Path "$env:APPDATA\Microsoft\Windows\Recent\*" -Force -Recurse -ErrorAction SilentlyContinue
    
    # Tweaks: Show Dialog Delete File
    Write-Host "[*] Mengaktifkan konfirmasi penghapusan file..." -ForegroundColor Cyan
    # Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" -Name "{59031a47-3f72-44a7-89c5-5595fe6b30ee}" -Value 1 -Force
    # Need to update registry setting for show delete confirmation (example: Recycle Bin Properties)

    # Tweaks: Hide Search Bar
    Write-Host "[*] Menyembunyikan Search Bar di Taskbar..." -ForegroundColor Cyan
    Set-ItemProperty -Path "HKCU:\Search" -Name "SearchboxTaskbarMode" -Value 0 -Force
    
    # Tweaks: Disable/Hide OneDrive
    Write-Host "[*] Menonaktifkan dan Menyembunyikan OneDrive..." -ForegroundColor Cyan
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive" -Name "DisableFileSyncNGSC" -Value 1 -Force -ErrorAction SilentlyContinue
    Set-ItemProperty -Path "HKCR:\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" -Name "System.IsPinnedToNameSpaceTree" -Value 0 -Force -ErrorAction SilentlyContinue

    Write-Host "[+] ARAI Selesai dieksekusi!" -ForegroundColor Green
    PauseMenu
}
