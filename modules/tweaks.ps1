function Show-Tweaks {

    while ($true) {

        Clear-Host
        Write-Host "==== WINDOWS TWEAKS ====" -ForegroundColor Magenta
        Write-Host "1. Enable Dark Mode"
        Write-Host "2. Show File Extensions"
        Write-Host "0. Back"
        Write-Host ""

        $choice = Read-Host "Select"

        switch ($choice) {

            "1" {
                Set-ItemProperty `
                -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize `
                -Name AppsUseLightTheme -Value 0

                Write-Host "Dark Mode Enabled"
                Pause
            }

            "2" {
                Set-ItemProperty `
                -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced `
                -Name HideFileExt -Value 0

                Write-Host "File Extensions Enabled"
                Pause
            }

            "0" { return }
        }
    }
}
