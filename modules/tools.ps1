function Menu-Tools {
    Clear-Host
    Write-Host "=== TOOLS WINDOWS ==="
    Write-Host "1. System Info"
    Write-Host "2. Scan SFC"
    Write-Host "0. Kembali"
    $c = Read-Host "Pilih"

    switch ($c) {
        "1" { 
            systeminfo
            Read-Host "`nTekan ENTER untuk kembali"
        }
        "2" { 
            sfc /scannow
            Read-Host "`nTekan ENTER untuk kembali"
        }
    }
}
