
<##############################################################################
 # PRIVATE PROPRTIES
 ##############################################################################>
$dataFile = "$env:APPDATA\psut\shortcuts.xml"

<##############################################################################
 # PUBLIC
 ##############################################################################>
function Get-Shortcuts() {
    $r = _GetRepository
    $r
}
function Add-Shortcut([string]$key, [string]$path) {    
    if ([String]::IsNullOrWhiteSpace($key)) {
        throw "Please specify a name for the shortcut"
    }
    if ([String]::IsNullOrWhiteSpace($path)) {
        throw "Please specify a path for the shortcut"
    }
    if (-Not(Test-Path $path)) {
        throw "The specified path for key '$path' is not valid"
    }
    $src = _GetRepository
    $src.Add($key, $path)
    _SaveRepository $src
}
function Remove-Shortcut([string]$key) {
    $src = _GetRepository
    $src.Remove($key);
    _SaveRepository($src)
}
function Invoke-Shortcut($key) {
    $src = _GetRepository
    if ($src.Contains($key)) {
        Set-Location $src[$key]
    }
    else { throw "The shortcut '$key' does not exist" }
}
function Clear-Shortcuts {
    $src = _GetRepository
    $src.Clear()
    _SaveRepository $src
}
<##############################################################################
 # PRIVATE FUNCTIONS
 ##############################################################################>
 
function _SaveRepository ([hashtable]$src) {
    if (-Not(Test-Path $dataFile)) {
        Write-Debug "Create a new repository for '$dataFile'"
        $null = New-Item -ItemType Directory -Force -Path $(Split-Path $dataFile)
    }

    $src | Export-Clixml $dataFile
}
function _GetRepository {
    if (-Not(Test-Path $dataFile)) {
        Write-Debug "No data file '$dataFile'"
        $result = @{}
    } 
    else {
        $result = Import-Clixml -path $dataFile
    }
    return $result
}
<##############################################################################
 # EXPORTS
 ##############################################################################>
 Export-ModuleMember -Function 'Get-Shortcuts'
 Export-ModuleMember -Function 'Add-Shortcut'
 Export-ModuleMember -Function 'Remove-Shortcut'
 Export-ModuleMember -Function 'Invoke-Shortcut'
 Export-ModuleMember -Function 'Clear-Shortcuts'