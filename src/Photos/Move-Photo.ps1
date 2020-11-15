function Get-CachedDate {
    $date = Get-Date("1970/1/1")

    if (Test-Path $path) {
        $date = Get-Date $(Get-Content $path)
    }

    return $date;
}

function Move-Photo {
    param (
        $src = "D:\DCIM\100CANON",
        $dst = "$env:userprofile\Downloads\Photos_Temp",
        $date = $null
    )
    $ErrorActionPreference = "Stop"
    $path = "$env:USERPROFILE\Documents\cached_date.txt"

    try {
        if ($null -eq $date) {
            $date = Get-CachedDate
        }

        Write-Host "Copying photo from $date to today..."

        if ($(Test-Path $src) -eq $false) {
            throw "The destination directory '$src' do not exist!"
        }
        if ($(Test-Path $dst) -eq $false) {
            mkdir $dst
        }

        Push-Location $src

        $files = Get-ChildItem -Recurse | where LastWriteTime -GE $(Get-Date $date)
        $dates = (Get-ChildItem -Recurse | where LastWriteTime -GE $(Get-Date $date) | select -ExpandProperty LastWriteTime) | select -ExpandProperty Date -unique

        foreach ($d in $dates) {    
            $dir = '{0:0000}-{1:00}-{2:00}' -f $d.Year, $d.Month, $d.Day

            $files | where { ($_.LastWriteTime).Date -eq $d } | % {
                $dstDir = "$dst\$dir"
                if ($(Test-Path $dst\$dir) -EQ $false) {
                    Write-Host "Create directory '$dstDir\'" -ForegroundColor Cyan
                    $null = mkdir $dstDir
                } 
        
                if (-not(Test-Path "$dstDir\$($_.Name)")) {
                    Copy-Item -Path $($_.FullName)  -Destination "$dstDir" 
                }
                else {
                    Write-Host "Skip file $($_.Name)." -ForegroundColor Yellow
                }
            }
        }
        Set-Content -Path $path -Value $(Get-Date) -NoNewline -Force
    }
    finally {
        Pop-Location
    }
}