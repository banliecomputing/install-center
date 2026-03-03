function Menu-Tweak {
    Clear-Host
    Write-Host "=== TWEAK SYSTEM ==="
    Write-Host "1. Show File Extension"
    Write-Host "0. Kembali"
    $c = Read-Host "Pilih"

    switch ($c) {
        "1" {
            Set-ItemProperty `
            -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" `
            -Name "HideFileExt" -Value 0
            Pause
        }
    }
}

function Show-MainMenu {
    do {
        Clear-Host
        Write-Host "==== INSTALL CENTER ===="
        Write-Host "1. Tools Windows"
        Write-Host "2. Install Aplikasi"
        Write-Host "3. Tweak System"
        Write-Host "0. Keluar"
        $m = Read-Host "Pilih"

        switch ($m) {
            "1" { Menu-Tools }
            "2" { Menu-Install }
            "3" { Menu-Tweak }
        }

    } while ($m -ne "0")
}
