. $PSScriptRoot\..\Photos\Get-NewestPhoto.ps1
. $PSScriptRoot\..\Photos\Move-Photo.ps1
. $PSScriptRoot\..\Photos\Move-PhotoFromPhone.ps1

<##############################################################################
 # EXPORTS
##############################################################################>

Export-ModuleMember -Function 'Get-NewestPhoto'
Export-ModuleMember -Function 'Move-Photo'    
Export-ModuleMember -Function 'Move-PhotoFromPhone' 