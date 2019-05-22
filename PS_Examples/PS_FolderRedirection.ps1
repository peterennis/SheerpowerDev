# Run the following command first in the console to bypass not digitally signed error
# Ref: http://tritoneco.com/2014/02/21/fix-for-powershell-script-not-digitally-signed/
# Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

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
$SetLocation = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders'
Write-Host
Write-Host "   >>> "'$SetLocation =' $SetLocation
Set-Location -path $SetLocation
# List the item properties
Get-ItemProperty -Path .

$SetLocation = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders'
Write-Host
Write-Host "   >>> "'$SetLocation =' $SetLocation
Set-Location -path $SetLocation
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

 