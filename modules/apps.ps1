function Show-Apps {

    while ($true) {

        Clear-Host
        Write-Host "==== APPLICATIONS ====" -ForegroundColor Green
        Write-Host "==== Browser Windows ====" 
        Write-Host "1. Install Google Chrome"
        Write-Host "2. Mozilla Firefox"
        Write-Host ""
        Write-Host "==== Media Player ====" -ForegroundColor Green
        Write-Host "3. Install 7zip"
        Write-Host "4. Install VLC"
        Write-Host "5. Acrobat Reader"
        Write-Host "6. WinRAR LAB"
        Write-Host ""
        Write-Host "7. Aimp Player"
        Write-Host "8. Google Chrome"
        Write-Host "0. Back"
        Write-Host ""

        $choice = Read-Host "Select"

        switch ($choice) {

            "1" {
                winget install Google.Chrome -e --silent
                Pause
            }
            
            "2" {
                 winget install -e --id Mozilla.Firefox
                Pause
            }   

            "3" {
                winget install 7zip.7zip -e --silent
                Pause
            }

            "4" {
                winget install VideoLAN.VLC -e --silent
                Pause
            }

            "5" {
                winget install Adobe.Acrobat.Reader.64-bit -e --id --silent
                Pause
            }
            
            "6" {
                winget install RARLab.WinRAR -e --id
                Pause
            }
            
            "7" {
                 winget install -e --id AIMP.AIMP
                Pause
            }       


            "8" {
                 winget install -e --id Google.Chrome
                Pause
            }    

            
            "0" { return }
        }
    }
}
