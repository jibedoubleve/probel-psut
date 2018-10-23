###############################################################################
### VARIABLES
###############################################################################
$focale = 18, 24, 35, 50, 85, 135
$speed = 30, 40, 60, 80, 160, 250

$answer = ""

$success = 0
$total = 0
###############################################################################
### FUNCTIONS
###############################################################################
function WriteSuccessColor([float]$rate) {
    if ($rate -le 50) {
        Write-Host "   " -BackGroundColor Red -NoNewLine
    }
    elseif ($rate -gt 50 -and $rate -lt 80) {
        Write-Host "   " -BackGroundColor Yellow -NoNewLine
    }
    else {
        Write-Host "   " -BackGroundColor Green -NoNewLine
    }
}

function GetSuccessValue($answer) {
    if ($answer -eq $speed[$i]) {
        Write-Host "CORRECT!" -ForegroundColor Green -NoNewline
        Write-Host " The answer is $($speed[$i])"
        return 1
    }
    else {
        Write-Host "WRONG " -ForegroundColor Red -NoNewline
        Write-Host "The answer is $($speed[$i]) [Your answer: $answer]"
        return 0
    }
}
###############################################################################
### MAIN
###############################################################################
function Invoke-LensTest {

    [int16]$count = Read-Host -Prompt "How many questions?"

    while ($count -gt 0) {
        $i = Get-Random -Minimum 0 -Maximum $focale.Length
        $answer = Read-Host -Prompt "What is the speed for $($focale[$i])"
        if ($answer -eq "quit") { break }

        Clear-Host
    
        $success += $(GetSuccessValue($answer))
    
        $total++
        $rate = $(($success / $total) * 100)
        WriteSuccessColor($rate)

        Write-Host " Score: $success / $total - $($rate.ToString("#.0"))  %  "
        $count--

    }
}