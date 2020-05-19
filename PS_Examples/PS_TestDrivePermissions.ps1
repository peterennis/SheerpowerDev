Clear-Host
Write-Host "Start=>" -BackgroundColor Magenta

# Get logged in user
$theLoggedInUser = $(whoami) # Returns domain name and username
$theLoggedInUserName = $theLoggedInUser.Substring(4)
Write-Host $theLoggedInUserName

# Get permissions on the W: drive
# Ref: https://social.technet.microsoft.com/wiki/contents/articles/7703.powershell-running-executables.aspx
$OutputFile = 'C:\TEMP\TestDrivePermissions.txt'
#$OutputFileCsv = 'C:\TEMP\TestDrivePermissions.csv'
$CMDPATH = 'C:\SysinternalsSuite\'
$CMD = $CMDPATH + 'accesschk.exe'
$arg1 = 'W:'
 
& $CMD $arg1 | Out-File -FilePath $OutputFile -Encoding ascii

# Write the contents of output file to txt, csv, and terminal
# Ref: https://docs.microsoft.com/en-us/windows/win32/secauthz/well-known-sids

#Get-Content -Path $OutputFile | Export-Csv -Path $OutputFileCsv -NoTypeInformation
#Get-Content -Path $OutputFile

#Write-Host $OutputFile

# Ref: https://www.business.com/articles/powershell-read-text-files/
# Ref: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/get-content?view=powershell-6
# The file is read into an array
$drivePermissions = Get-Content -Path $OutputFile
<#
$drivePermissions.GetType() | Format-Table -AutoSize
$drivePermissions[0]
$drivePermissions[1]
$drivePermissions[2]
$drivePermissions[3]
#>

# Read information for current user from the permissions file
Write-Host 'A '$theLoggedInUserName
Write-Host
Write-Host 'B '$OutputFile
Write-Host
Write-Host 'C '$drivePermissions

$myPermissions = Get-Content -Path $OutputFile | Where-Object { $_ -like '*peterennis*' }
Write-Host 'D '$myPermissions 
$myPermissions[0]
$myPermissions[1]

# The "Access Denied" error is occurred because the "C:\System Volume Information"
# is a system folder that is used from Windows to store information about the system
# restore points and by default this folder is not accessible by users. 
# Ref: https://www.repairwin.com/fix-access-denied-system-volume-information-folder/
$theLastLine = Get-Item -Path $OutputFile | Get-Content -Tail 2
Write-Host 'E '$theLastLine is the last non-empty line

Write-Host "<=End" -BackgroundColor Magenta
