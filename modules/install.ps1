function Show-Apps {
    while ($true) {
        Clear-Host
        Write-Host "==== APPLICATIONS ====" -ForegroundColor Green
        Write-Host "1. Install Google Chrome"
        Write-Host "2. Install 7zip"
        Write-Host "0. Back"
        Write-Host ""

        $choice = Read-Host "Select"

        switch ($choice) {
            "1" {
                winget install Google.Chrome -e
                Pause
            }
            "2" {
                winget install 7zip.7zip -e
                Pause
            }
            "0" { return }
        }
    }
}
