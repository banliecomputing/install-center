function Show-WindowsTools {

    while ($true) {

        Clear-Host
        Write-Host "==== WINDOWS TOOLS ====" -ForegroundColor Yellow
        Write-Host "1. System Information"
        Write-Host "2. Disk Cleanup"
        Write-Host "3. Check Disk (C:)"
        Write-Host "4. Keyboard Tester Portable"
        Write-Host "5. Auto Driver Updater (Windows 10/11)"
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
                $url = "https://github.com/banliecomputing/install-center/releases/download/v1.0/Keyboard.Test.Portable.exe"
                $path = "$env:TEMP\keyboardtester.exe"
                
                if (-not (Test-Path $path)) {
                    Write-Host "Downloading Keyboard Tester..."
                    irm $url -OutFile $path
                }
                Start-Process $path
                Pause
            }

            "5" {
                try {
                    $url = "https://raw.githubusercontent.com/banliecomputing/install-center/main/modules/Auto-Driver-Updater-W10.ps1"
                    irm $url | iex
                }
                catch {
                    Write-Host "Failed to run Driver Updater" -ForegroundColor Red
                }
            
                Pause
            }
                        
            "0" { return }
        }
    }
}
