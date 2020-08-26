function Get-NewestPhoto {
    Get-ChildItem -Recurse -af | select -ExpandProperty lastwritetime | measure -Maximum
}