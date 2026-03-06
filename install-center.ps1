# =============================
# INSTALL CENTER v2 STABLE
# =============================

# HASH PASSWORD: Sukse
$PasswordHash = "5ed701c5c57b79fc7abc8e596ecd1143065537266ab7817e5ac6c45973262590"

function Test-Password {

    $secure = Read-Host "Enter Password" -AsSecureString
    $ptr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure)
    $plain = [Runtime.InteropServices.Marshal]::PtrToStringAuto($ptr)

    $sha = New-Object System.Security.Cryptography.SHA256Managed
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($plain)
    $hashBytes = $sha.ComputeHash($bytes)

    $builder = New-Object System.Text.StringBuilder
    foreach ($b in $hashBytes) {
        [void]$builder.Append($b.ToString("x2"))
    }

    $hash = $builder.ToString()

    if ($hash -eq $PasswordHash) {
        return $true
    }
    else {
        return $false
    }
}

# ===== PASSWORD LOOP =====
while (-not (Test-Password)) {
    Write-Host "Wrong password. Try again." -ForegroundColor Red
    Start-Sleep 1
}

# ===== LOAD MODULES =====
$base = "https://raw.githubusercontent.com/banliecomputing/install-center/main/modules"

try {
    irm "$base/windows-tools.ps1" | iex
    irm "$base/apps.ps1" | iex
    irm "$base/tweaks.ps1" | iex
    irm "$base/online-scripts.ps1" | iex
}
catch {
    Write-Host "Failed to load modules." -ForegroundColor Red
    Pause
    return
}

# ===== MAIN MENU =====
function Show-MainMenu {

    while ($true) {

        Clear-Host
        Write-Host "   ======== INSTALL CENTER ========" -ForegroundColor Cyan
        Write-Host "   "
        Write-Host "   1. Windows Tools" -ForegroundColor Blue
        Write-Host "   2. Applications" -ForegroundColor Magenta
        Write-Host "   3. Tweaks" -ForegroundColor Yellow
        Write-Host "   4. Online Scripts" -ForegroundColor Red
        Write-Host "   ==========================" -ForegroundColor Cyan
        Write-Host "   0. Exit"
        Write-Host ""

        $choice = Read-Host "Select Menu"

        switch ($choice) {
            "1" { Show-WindowsTools }
            "2" { Show-Apps }
            "3" { Show-Tweaks }
            "4" { Show-OnlineScripts }
            "0" { return }
            default {
                Write-Host "Invalid choice"
                Start-Sleep 1
            }
        }
    }
}

Show-MainMenu
