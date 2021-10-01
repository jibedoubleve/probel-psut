
$path = "$env:USERPROFILE\Documents\cached_date.txt"

function Get-CachedDate {
    $date = Get-Date("1970/1/1")
    
    if (Test-Path $path) {
        $date = Get-Date $(Get-Content $path)
    }

    return $date
}

function Set-CachedDate {    
    Set-Content -Path $path -Value $(Get-Date) -NoNewline -Force
}

function Copy-File ($file, $dst) {

    $d = $file.LastWriteTime
    $srcName = '{0:0000}-{1:00}-{2:00}' -f $d.Year, $d.Month, $d.Day
    $destination = Join-Path -Path $dst -ChildPath $srcName

    if (-not(Test-Path $destination)) {
        Write-Host " (New DIR)" -ForegroundColor Yellow -NoNewline
        $c = mkdir $destination
    }
    
    $destPath = Join-Path -Path $destination -ChildPath $file.Name
    if (-not([System.Io.File]::Exists($destPath))) {
        Copy-Item -Path $file -Destination $destination
        Write-Host " DONE " -ForegroundColor DarkGreen
    }
    else {
        Write-Host " SKIPPED" -ForegroundColor DarkRed
    }
}

function Move-Photo {
    param (        
        $relativeSrc = "DCIM",
        $dst = "$env:userprofile\Downloads\Photos_Temp",
        $date = $null
    )
    $ErrorActionPreference = "Stop"

    try {
        if ($null -eq $date) {
            $date = Get-CachedDate
        }    

        $path = "$env:USERPROFILE\Documents\cached_date.txt"
        $drives = Get-PSDrive -PSProvider FileSystem

        foreach ($drive in $drives) {
            Write-Host "Looking into drive $($drive.Root)" -ForegroundColor Cyan
    
            $fullPath = Join-Path -Path $drive.Root -ChildPath $relativeSrc

            if (Test-Path $fullPath) {
                $dirList = Get-ChildItem -Path $fullPath -Directory | where { $_.Name -Match "\d{3}CANON" }

                foreach ($dir in $dirList) {
                    Write-Host "`t $($dir.Name)" -ForegroundColor DarkBlue

                    $files = Get-ChildItem -Path $dir -Recurse | where LastWriteTime -GT $(Get-Date $date)                                           
                    foreach ($file in $files) {  
                        $dateStr = '{0:0000}-{1:00}-{2:00}' -f $file.LastWriteTime.Year, $file.LastWriteTime.Month, $file.LastWriteTime.Day
                        Write-Host "`t`tCopying $($file.Name) [$dateStr]..." -NoNewline
                        Copy-File -file $file -dst $dst
                    }      
                } 
            }
        }

        Set-CachedDate
    }
    catch {
        Write-Host "An error occured: $($_.Message)" -ForegroundColor Yellow -BackgroundColor Red
        Write-Host $_ -ForegroundColor Red
    }    
}