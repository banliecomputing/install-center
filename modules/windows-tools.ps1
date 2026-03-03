function Show-WindowsTools {

    while ($true) {

        Clear-Host
        Write-Host "==== WINDOWS TOOLS ====" -ForegroundColor Yellow
        Write-Host "1. System Information"
        Write-Host "2. Disk Cleanup"
        Write-Host "3. Check Disk (C:)"
        Write-Host "4. Keyboard Tester Portable (C:)"
        Write-Host "0. Back"
        Write-Host ""

        $choice = Read-Host "Select"

        switch ($choice) {

            "1" {
                systeminfo
                Pause
            }

            "2" {
                cleanmgr
                Pause
            }

            "3" {
                chkdsk C:
                Pause
            }

            "4" {
            $url = "LINK_DOWNLOAD_EXE_KAMU"
            $path = "$env:TEMP\keyboardtester.exe"
            if (-not (Test-Path $path)) {
            Write-Host "Downloading Keyboard Tester..."
            irm $url -OutFile $path
            }
            Start-Process $path
            Pause
            }
            
            "0" { return }
        }
    }
}
