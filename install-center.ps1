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

# ===== PASSWORD CHECK (SHA256 of: Archer123) =====
# $PasswordHash = "3b5d5c3712955042212316173ccf37be80000000000000000000000000000000"  # sementara dummy
$PasswordHash = "8f7b7dfd9a5c6c8f4e3f6b1e9c1f4a8b7d5e2c3f9a6b4d1e8c7f0a2b5d6e7f8a"

$inputPass = Read-Host "Masukkan Password"
$sha = [System.Security.Cryptography.SHA256]::Create()
$hash = [BitConverter]::ToString(
    $sha.ComputeHash([Text.Encoding]::UTF8.GetBytes($inputPass))
).Replace("-","").ToLower()

if ($hash -ne $PasswordHash) {
    Write-Host "Password salah!"
    exit
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
    irm "$Repo/modules/$m" | iex
}

Show-MainMenu
