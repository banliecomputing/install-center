# ========================================
# MODULE: ONLINE SCRIPT CENTER
# ========================================

function Show-OnlineScripts {

    # Menggunakan ScriptBlock (Action) agar lebih fleksibel membedakan antara Skrip dan Website
    $scripts = @{
        1 = @{
            Name = "Microsoft Activation Script (MAS)"
            Action = { irm "https://get.activated.win" | iex }
        }
        2 = @{
            Name = "Windows Utility - Chris Titus"
            Action = { irm "https://christitus.com/win" | iex }
        }
        3 = @{
            Name = "Windows Debloat Tool (Raphi)"
            Action = { irm "https://debloat.raphi.re/" | iex }
        }
        4 = @{
            Name = "Office Installer Tool"
            Action = { irm "https://officetool.plus/otool/otool.ps1" | iex }
        }
        5 = @{
            Name = "Reset Windows Update"
            Action = { irm "https://raw.githubusercontent.com/wureset-tools/windows-update-reset/main/reset.ps1" | iex }
        }
        6 = @{
            Name = "Microsoft PC Manager (Buka di Browser)"
            Action = { Start-Process "https://pcmanager.microsoft.com" }
        }
        7 = @{
            Name = "Banlie Billing REPORT"
            Action = {  irm "https://gist.github.com/banliecomputing/6f0feda4f4797ba126eeb8d47da6d66c/raw/banlie.ps1" | iex  }
        }
    }

    while ($true) {

        Show-Header

        Write-Host "========== ONLINE SCRIPT CENTER ==========" -ForegroundColor Cyan
        Write-Host ""
        Write-Host " Remote tools executed directly from internet" -ForegroundColor DarkGray
        Write-Host ""

        # Sortir berdasarkan angka (key integer) agar urutan tidak berantakan jika > 9
        $sortedKeys = $scripts.Keys | Sort-Object

        foreach ($key in $sortedKeys) {
            Write-Host " $key. $($scripts[$key].Name)"
        }

        Write-Host ""
        Write-Host " 0. Back"
        Write-Host ""

        $choice = Read-Host "Select"

        if ($choice -eq "0") { return }

        # Konversi input user ke integer untuk pencocokan key
        $choiceInt = 0
        if ([int]::TryParse($choice, [ref]$choiceInt) -and $scripts.ContainsKey($choiceInt)) {
            
            Show-Header

            Write-Host "Mengeksekusi: $($scripts[$choiceInt].Name)" -ForegroundColor Yellow
            Write-Host ""

            try {
                # Menjalankan Action / ScriptBlock sesuai pilihan
                & $scripts[$choiceInt].Action
            } catch {
                Write-Host ""
                Write-Host "Gagal mengeksekusi skrip atau dibatalkan: $($_.Exception.Message)" -ForegroundColor Red
            }

            PauseMenu

        } else {
            Write-Host "Pilihan tidak valid." -ForegroundColor Red
            Start-Sleep -Seconds 1
        }
    }
}
