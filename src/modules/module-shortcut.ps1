
<##############################################################################
 # PRIVATE PROPRTIES
 ##############################################################################>
 $dirFile = "$env:USERPROFILE\Documents\shortcuts.json"
 $dir = @{ }
 $isDirLoaded = $false
 $edit = "notepad.exe"
 <##############################################################################
  # PUBLIC
  ##############################################################################>
 function Invoke-Shortcut($location) {   
     if ($isDirLoaded -eq $false) {
         $dir = Get-Shortcuts
         $isDirLoaded = $true
     }
     Push-Location
     Set-Location $dir.$location
 }
 function Save-Shortcuts {
     $dir.GetEnumerator() | ConvertTo-Json | Out-File $dirFile
 }
 function Get-Shortcuts {
     Write-Host "Loading shortcuts..." -ForegroundColor DarkCyan
     $hashtable = @{}
 
     (Get-Content $dirFile | ConvertFrom-Json) | % {
         $hashtable[$_.Name] = $_.Value 
     }
     return $hashtable
 }
 function Add-Shortcut($name, $path) {
     $dir = Get-Shortcuts
     $dir.Add($name, $path)
     Save-Shortcuts
 }
 
 function Edit-Shortcuts {
     &$edit $dirFile
 }
 function Remove-Shortcut($name) {
     $dir.Remove($name)
     Save-Shortcuts
 }
 <##############################################################################
  # PRIVATE FUNCTIONS
  ##############################################################################>
  
 <##############################################################################
  # EXPORTS
  ##############################################################################>
 New-Alias -Name lss -Value Get-Shortcuts
 New-Alias -Name ads -Value Add-Shortcut
 New-Alias -Name rms -Value Remove-Shortcut
 New-Alias -Name go  -Value Invoke-Shortcut
 
 Export-ModuleMember -Function 'Get-Shortcuts'   -Alias lss
 Export-ModuleMember -Function 'Add-Shortcut'    -Alias ads
 Export-ModuleMember -Function 'Remove-Shortcut' -Alias rms
 Export-ModuleMember -Function 'Invoke-Shortcut' -Alias go
 Export-ModuleMember -Function 'Clear-Shortcuts'
 Export-ModuleMember -Function "Edit-Shortcuts"
 