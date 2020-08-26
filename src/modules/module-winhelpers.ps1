<##############################################################################
 # PUBLIC
 ##############################################################################>
function Get-InstallDate() {
    $os = get-wmiobject win32_operatingsystem
    return $os.ConvertToDateTime($os.InstallDate) -f "MM/dd/yyyy" 
}
function Invoke-LogOff {
    shutdown /l
}
function Invoke-Halt {
    shutdown -s -t 0
}
function Get-Colors {
    Write-Host ""
    [System.Enum]::GetValues("consolecolor") | % {
        Write-Host "          " -BackgroundColor $_ -NoNewline
        Write-Host " $_" 
    }
    Write-Host ""
}function Test-Administrator {
    $user = [Security.Principal.WindowsIdentity]::GetCurrent();
    (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}
<##############################################################################
 # EXPORTS
 ##############################################################################>
New-Alias -Name idate  -Value Get-InstallDate
New-Alias -Name logoff -Value Invoke-LogOff
New-Alias -Name halt   -Value Invoke-Halt

Export-ModuleMember -Function 'Get-InstallDate' -Alias idate
Export-ModuleMember -Function 'Invoke-LogOff'   -Alias logoff
Export-ModuleMember -Function 'Invoke-Halt'     -Alias halt
Export-ModuleMember -Function 'Test-Administrator'
Export-ModuleMember -Function 'Get-Colors'
