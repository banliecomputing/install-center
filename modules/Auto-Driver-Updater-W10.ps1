# ========================================
# AUTO DRIVER UPDATER v4.0 (Interactive Menu)
# (Disimpan sebagai diagnostic.ps1)
# ========================================

# Set Window Title & Timezone
Set-TimeZone -Id "SE Asia Standard Time"
Start-Sleep -Seconds 1
$host.ui.RawUI.WindowTitle = "Auto Driver Updater v4.0 (Interactive) mod  Foxway A/S by Johny Bartholdy Jensen [$(Get-Date -Format 'HH:mm')]"

# Set Brightness to 100%
$monitor = Get-CimInstance -Namespace root/wmi -ClassName WmiMonitorBrightnessMethods -ErrorAction SilentlyContinue
if ($monitor) { Invoke-CimMethod -InputObject $monitor -MethodName WmiSetBrightness -Arguments @{Timeout=1; Brightness=100} -ErrorAction SilentlyContinue }
Clear-Host

# ================= UI & TEXT FUNCTIONS =================
function text_time { Write-Host "`nMemperbarui waktu sistem..." -ForegroundColor Green }
function text_search { Write-Host "`nMencari pembaruan driver (Mohon tunggu)..." -ForegroundColor Cyan }
function text_no_internet { Write-Host "`nKoneksi internet tidak ditemukan!" -ForegroundColor Red }
function text_reboot { Write-Host "`nSistem perlu di-restart! Komputer akan restart dalam 10 detik!" -ForegroundColor Red }

# ================= VALIDATION FUNCTIONS =================
function test_ifmodel {
    $systemfamily = (Get-CimInstance win32_computersystem).SystemFamily
    if ($systemfamily -match "ThinkPad P16s Gen 1"){
        Add-Type -AssemblyName PresentationFramework
        $msg = "Laptop P16s harus menjalankan 'TVSU' sebelum menjalankan 'Auto Driver Updater'. Tanyakan pada Team Leader untuk info lebih lanjut.`n`nApakah Anda sudah menjalankan TVSU?"
        $msgBoxInput = [System.Windows.MessageBox]::Show($msg, 'ThinkPad P16s Terdeteksi', 'YesNo', 'Error')
        
        if ($msgBoxInput -eq 'No') { throw "Dibatalkan oleh pengguna." }
    }
}

function test_network {
    try {
        $tcpClient = New-Object Net.Sockets.TcpClient
        $async = $tcpClient.BeginConnect("8.8.8.8", 53, $null, $null)
        $wait = $async.AsyncWaitHandle.WaitOne(1500) # Timeout 1.5 Detik
        
        if (-not $wait) { throw "Timeout" }
        $tcpClient.EndConnect($async)
        $tcpClient.Close()
    } catch {
        text_no_internet
        throw "Koneksi internet terputus."
    }
}

# ================= START SCRIPT / MAIN FUNCTION =================
function Show-Diagnostic {
    # Predefined Variables
    $rebootrequired = $false

    try {
        test_ifmodel
        test_network
    } catch {
        Write-Host "Dibatalkan: $($_.Exception.Message)" -ForegroundColor Red
        PauseMenu
        return # Kembali ke menu utama Install Center
    }

    Write-Host "Aktivasi Windows..." -ForegroundColor Yellow
    slmgr -ato | Out-Null

    text_time

    # Start the Windows Time service
    try {
        $service = Get-Service -Name w32time -ErrorAction Stop
        if ($service.Status -ne "Running") {
            Start-Service -Name w32time
            Write-Host "Service Waktu Windows berhasil dijalankan." -ForegroundColor Cyan
        }
    } catch {
        Write-Host "Gagal menjalankan Service Waktu Windows." -ForegroundColor Red
    }

    # Trigger time synchronization
    try {
        w32tm /resync /rediscover | Out-Null
        Write-Host "Sinkronisasi waktu berhasil." -ForegroundColor Cyan
    } catch {
        Write-Host "Gagal melakukan sinkronisasi waktu." -ForegroundColor Red
    }

    # ================= MAIN MENU LOOP =================
    while ($true) {
        try { test_network } catch { return }
        
        # Initialize COM Object for Windows Update
        $Session = New-Object -ComObject Microsoft.Update.Session            
        $Searcher = $Session.CreateUpdateSearcher() 
        $Searcher.ServiceID = '7971f918-a847-4430-9279-4a52d1efe18d' # Microsoft Update Service GUID
        $Searcher.SearchScope = 1 # MachineOnly
        $Searcher.ServerSelection = 2 # Third Party
        
        $Criteria = "IsInstalled=0 and Type='Driver' and ISHidden=0"
        text_search
        
        # Pencarian Update
        $SearchResult = $Searcher.Search($Criteria)          
        $Updates = $SearchResult.Updates
        
        # Jika tidak ada update
        if (-not $Updates -or $Updates.Count -eq 0) { 
            Write-Host "`nTidak ada pembaruan driver yang tersedia atau semua driver sudah up-to-date." -ForegroundColor Green
            break 
        }

        # Tampilkan Menu Driver
        Write-Host "`n========================================================" -ForegroundColor Yellow
        Write-Host " DAFTAR DRIVER YANG TERSEDIA UNTUK DIINSTALL" -ForegroundColor Yellow
        Write-Host "========================================================" -ForegroundColor Yellow
        
        for ($i = 0; $i -lt $Updates.Count; $i++) {
            $driver = $Updates.Item($i)
            Write-Host " [$($i + 1)] $($driver.DriverModel)" -ForegroundColor Cyan
            Write-Host "     Tipe: $($driver.Driverclass)" -ForegroundColor DarkGray
        }
        
        Write-Host "--------------------------------------------------------"
        Write-Host " [A] Install SEMUA Driver" -ForegroundColor Green
        Write-Host " [0] Keluar / Batal" -ForegroundColor Red
        Write-Host "========================================================" -ForegroundColor Yellow

        $userInput = Read-Host "`nMasukkan pilihan Anda (Contoh: '1', '1,3,4', 'A', atau '0')"

        if ($userInput -eq '0') {
            Write-Host "Keluar dari menu updater..." -ForegroundColor Yellow
            break
        }

        # Parsing Input User
        $selectedUpdates = New-Object System.Collections.ArrayList

        if ($userInput -match '^[aA]$') {
            # Pilih semua
            for ($i = 0; $i -lt $Updates.Count; $i++) {
                $null = $selectedUpdates.Add($Updates.Item($i))
            }
        } else {
            # Pilih spesifik berdasarkan angka koma
            $selections = $userInput -split ','
            foreach ($sel in $selections) {
                $index = 0
                if ([int]::TryParse($sel.Trim(), [ref]$index)) {
                    if ($index -ge 1 -and $index -le $Updates.Count) {
                        $null = $selectedUpdates.Add($Updates.Item($index - 1))
                    } else {
                        Write-Host "Nomor [$index] tidak valid dan akan dilewati." -ForegroundColor Red
                    }
                }
            }
        }

        if ($selectedUpdates.Count -eq 0) {
            Write-Host "Tidak ada driver valid yang dipilih. Silakan coba lagi." -ForegroundColor Red
            Start-Sleep -Seconds 2
            continue
        }

        $UpdateSession = New-Object -ComObject Microsoft.Update.Session
        $TotalSelected = $selectedUpdates.Count

        # ================= DOWNLOAD PROCESS =================
        Write-Host "`nMemulai proses unduhan..." -ForegroundColor Yellow
        $CompletedUpdates = 0

        foreach ($Update in $selectedUpdates) {
            $CompletedUpdates++
            
            $SingleUpdateColl = New-Object -ComObject Microsoft.Update.UpdateColl
            $SingleUpdateColl.Add($Update) | Out-Null
            
            $Downloader = $UpdateSession.CreateUpdateDownloader()
            $Downloader.Updates = $SingleUpdateColl
            
            $UpdateTitle = "[$CompletedUpdates/$TotalSelected] " + $Update.DriverModel
            $PercentComplete = ($CompletedUpdates / $TotalSelected) * 100
            Write-Progress -Activity "Mengunduh Driver" -Status "Sedang mengunduh..." -CurrentOperation $UpdateTitle -PercentComplete $PercentComplete
            
            if (-not $Update.EulaAccepted) { $Update.AcceptEula() }
            $Downloader.Download() | Out-Null
        }
        Write-Progress -Activity "Mengunduh Driver" -Completed
            
        # ================= INSTALLATION PROCESS =================
        Write-Host "Memulai proses instalasi..." -ForegroundColor Yellow
        $CompletedInstalls = 0
        
        foreach ($Update in $selectedUpdates) {
            $CompletedInstalls++
            
            $SingleInstallColl = New-Object -ComObject Microsoft.Update.UpdateColl
            $SingleInstallColl.Add($Update) | Out-Null
            
            $Installer = $UpdateSession.CreateUpdateInstaller()
            $Installer.Updates = $SingleInstallColl
            
            $UpdateTitle = "[$CompletedInstalls/$TotalSelected] " + $Update.DriverModel
            $PercentComplete = ($CompletedInstalls / $TotalSelected) * 100
            Write-Progress -Activity "Menginstal Driver" -Status "Sedang menginstal..." -CurrentOperation $UpdateTitle -PercentComplete $PercentComplete
            
            $Installer.Install() | Out-Null
        }
        Write-Progress -Activity "Menginstal Driver" -Completed
        
        Write-Host "`nInstalasi selesai!" -ForegroundColor Green
        $rebootrequired = $true

        # Konfirmasi apakah ingin scan ulang
        Write-Host ""
        $rescan = Read-Host "Apakah Anda ingin memindai (scan) driver lagi? (Y/N)"
        if ($rescan -notmatch '^[yY]$') {
            break
        }
        Clear-Host
    }

    # ================= CLEAN UP =================
    try {
        $updateSvc = New-Object -ComObject Microsoft.Update.ServiceManager
        $updateSvc.Services | 
            Where-Object { $_.IsDefaultAUService -eq $false -and $_.ServiceID -eq "7971f918-a847-4430-9279-4a52d1efe18d" } | 
            ForEach-Object { $updateSvc.RemoveService($_.ServiceID) }
    } catch {
        Write-Host "Cleanup dilewati." -ForegroundColor DarkGray
    }

    # ================= FINAL CHECK & REBOOT =================
    try { test_network } catch { return }

    if ($rebootrequired) {  
        text_reboot
        Start-Sleep -Seconds 10
        Restart-Computer -Force
    } else {
        Write-Host "`nTidak ada perubahan sistem yang membutuhkan Restart." -ForegroundColor Green
    }

    Write-Host "`nProses selesai."
    PauseMenu
}
