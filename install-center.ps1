# ===============================
# INSTALL CENTER LOADER
# ===============================

$Repo = "https://raw.githubusercontent.com/banliecomputing/install-center/main"
$CurrentVersion = "1.0"
$LogFile = "$env:TEMP\install-center.log"

# ===== LOG FUNCTION =====
function Write-Log {
    param($msg)
    $time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$time - $msg" | Out-File -Append $LogFile
}

function Pause {
    Read-Host "`nTekan ENTER untuk kembali"
}

# ===== PASSWORD CHECK =====
# SHA256 untuk: Sukses88
$PasswordHash = "5ed701c5c57b79fc7abc8e596ecd1143065537266ab7817e5ac6c45973262590"

$inputPass = Read-Host "Masukkan Password"
$sha = [System.Security.Cryptography.SHA256]::Create()
$hash = [BitConverter]::ToString(
    $sha.ComputeHash([Text.Encoding]::UTF8.GetBytes($inputPass))
).Replace("-","").ToLower()

if ($hash -ne $PasswordHash) {
    Write-Host "Password salah!"
    Pause
    return
}

Write-Log "Login berhasil"

# ===== UPDATE CHECK =====
try {
    $LatestVersion = irm "$Repo/version.txt"
    if ($LatestVersion -ne $CurrentVersion) {
        Write-Host "Versi baru tersedia: $LatestVersion"
    }
} catch {}

# ===== LOAD MODULES =====
$Modules = @("install.ps1","tools.ps1","tweak.ps1")

foreach ($m in $Modules) {
    try {
        irm "$Repo/modules/$m" | iex
    } catch {
        Write-Host "Gagal load module $m"
        Pause
        return
    }
}

Show-MainMenu
