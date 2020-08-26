function Move-PhotoFromPhone {
    $src = "D:\OneDrive\Pictures\Camera Roll"
    $dst = "D:\OneDrive\-----06.Photos"
    $dirTitle = "Divers"

    $dates = gci $src | select LastWriteTime | % {
        $d = $_.LastWriteTime
        return '{0:0000}-{1:00}-{2:00}' -f $d.Year, $d.Month, $d.Day
        # return "$($($_.LastWriteTime).Year)-$($($_.LastWriteTime).Month)"

    } | select -unique

    # Create the year directories if not exits
    $dates | % { $($_ -split '-')[0] } | select -Unique | % {
        $p = "$dst\$_"
        if (Test-Path $p) {
            Write-Host "Directory '$p' already exists." -ForegroundColor Yellow
        }
        else {
            mkdir $p 
        }
    }

    # Create the months directories if not exists
    $dates | select -Unique | % {
        $s = $_ -split '-'
        $year = $s[0]
        $month = "{0:0000}-{1:00}-xx" -f $s[0], $s[1]
        $p = "$dst\$year\$month $dirTitle"

        if (Test-Path $p) {
            Write-Host "Subdirectory '$p' already exists." -ForegroundColor Yellow
        }
        else {
            mkdir $p 
        }
    }

    # Copy files into the resulting directory
    gci $src | % {
        $year = $($_.LastWriteTime).Year
        $month = $($_.LastWriteTime).Month    

    
        $dest = "$dst\{0:0000}\{0:0000}-{1:00}-xx $dirTitle" -f $year, $month
        Write-Host "File: $($_.FullName) --> $($dst)" -ForegroundColor Cyan
        mv $_.FullName -Destination $dest #-WhatIf
    } 
}