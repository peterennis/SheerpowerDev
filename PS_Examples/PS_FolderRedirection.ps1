
$Date = Get-Date
Write-Host "Today is"$Date

Write-Host "The current logged in user:"
Write-Host "   >>> "'$ENV:UserName =' $ENV:UserName

# $DomainServer = Read-Host -Prompt 'Input the domain server name'
$DomainServer = 'RDADC'
Write-Host "   >>> "'$DomainServer =' $DomainServer

# $User = Read-Host -Prompt 'Input the user name'
# Write-Host "   >>> "'$User =' $User

# Set the reg key location
Set-Location -path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders'
# List the item properties
Get-ItemProperty -Path .




Exit

# reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v "Desktop" /d "\\misdc01\FolderRedirections\%USERNAME%\Desktop" /f
# reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v "My Video" /d "\\misdc01\FolderRedirections\%USERNAME%\My Videos" /f
# reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v "My Music" /d "\\misdc01\FolderRedirections\%USERNAME%\My Music" /f
# reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v "My Pictures" /d "\\misdc01\FolderRedirections\%USERNAME%\My Pictures" /f
# reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v "Favorites" /d "\\misdc01\FolderRedirections\%USERNAME%\My Pictures" /f
# reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v "Personal" /d "\\misdc01\FolderRedirections\%USERNAME%" /f
# reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v "Desktop" /d "\\misdc01\FolderRedirections\%USERNAME%\Desktop" /f
# reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v "My Video" /d "\\misdc01\FolderRedirections\%USERNAME%\My Videos" /f
# reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v "My Music" /d "\\misdc01\FolderRedirections\%USERNAME%\My Music" /f
# reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v "My Pictures" /d "\\misdc01\FolderRedirections\%USERNAME%\My Pictures" /f
# reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v "Favorites" /d "\\misdc01\FolderRedirections\%USERNAME%\My Pictures" /f

 