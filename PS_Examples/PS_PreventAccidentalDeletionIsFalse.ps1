$MyOrg = Get-ADOrganizationalUnit -filter *
Write-Host "MyOrg:`n"$MyOrg

$NotProtected = Get-ADOrganizationalUnit -filter * -Properties ProtectedFromAccidentalDeletion |`
    Where-Object { $_.ProtectedFromAccidentalDeletion -eq $false }

Write-Host "NotProtected:`n"$NotProtected`n

$Protected = Get-ADOrganizationalUnit -filter * -Properties ProtectedFromAccidentalDeletion |`
    Where-Object { $_.ProtectedFromAccidentalDeletion -eq $true }

Write-Host "Protected:`n"$Protected

$MyUsers = Get-ADuser -Property * 
Write-Host "MyUsers:`n"$MyUsers

Get-ADobject -Filter * -SearchBase “OU=Users,DC=Domain,DC=com” | Set-adobject -ProtectedFromAccidentalDeletion $true

pause