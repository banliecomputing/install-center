function Show-OnlineScripts {

    $scripts = @{
        "1" = @{
            Name = "Microsoft Activation Script (massgrave)"
            Url  = "https://get.activated.win"
        }
        
        "2" = @{
            Name = "Windows Tewak (christitus)"
            Url  = "http://christitus.com/win"
        }       
        
        "3" = @{
            Name = "Example Script"
            Url  = "https://example.com/script.ps1"
        }
        
    }

    while ($true) {

        Clear-Host
        Write-Host "==== ONLINE SCRIPTS ====" -ForegroundColor Cyan

        foreach ($key in $scripts.Keys) {
            Write-Host "$key. $($scripts[$key].Name)"
        }

        Write-Host "0. Back"
        Write-Host ""

        $choice = Read-Host "Select"

        if ($choice -eq "0") { return }

        if ($scripts.ContainsKey($choice)) {

            Write-Host "Running $($scripts[$choice].Name)..."
            irm $scripts[$choice].Url | iex
            Pause
        }
    }
}
