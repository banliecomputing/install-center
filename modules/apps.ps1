function Show-Apps {

    while ($true) {

        Clear-Host
        Write-Host "==== APPLICATIONS ====" -ForegroundColor Green
        Write-Host "1. Install Google Chrome"
        Write-Host "2. Install 7zip"
        Write-Host "3. Install VLC"
        Write-Host "4. Acrobat Reader"
        Write-Host "0. Back"
        Write-Host ""

        $choice = Read-Host "Select"

        switch ($choice) {

            "1" {
                winget install Google.Chrome -e --silent
                Pause
            }

            "2" {
                winget install 7zip.7zip -e --silent
                Pause
            }

            "3" {
                winget install VideoLAN.VLC -e --silent
                Pause
            }

            "4" {
                winget Adobe.Acrobat.Reader.64-bit -e --silent
                Pause
            }
            
            "0" { return }
        }
    }
}
