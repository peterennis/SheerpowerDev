# Ref: http://blogs.technet.com/b/heyscriptingguy/archive/2011/11/13/use-powershell-to-quickly-find-installed-software.aspx

# Get-ExecutionPolicy 
# The command shows the current script execution policy
# Ref: http://technet.microsoft.com/library/hh847748.aspx
# Ref: http://technet.microsoft.com/en-us/library/hh849812.aspx
# Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted
# The command uses the Set-ExecutionPolicy cmdlet to set an execution policy of Unrestricted for the current user.

Clear-Host

Write-Host "Start=>"

### Ref: https://www.petri.com/how-to-get-ntfs-file-permissions-using-powershell
#Get-Acl -Path W:\peterennis | Format-Table -Wrap

### Get more information
#Get-Acl -Path W:\peterennis | Format-List

### Get specific information
#(Get-Acl -Path W:\peterennis).Access

### Show users or groups listed in the ACL
#(Get-Acl -Path W:\peterennis).Access.IdentityReference

# Generate a report on a folder hierarchy
$FolderPath = Get-ChildItem -Directory -Path "C:\TEMP" -Recurse -Force
Write-Host $FolderPath
ForEach ($Folder in $FolderPath) {
    $Acl = Get-Acl -Path $Folder.FullName
    ForEach ($Access in $Acl.Access) {
        $Properties = [ordered]@{'Folder Name' = $Folder.FullName; 'Group/User' = $Access.IdentityReference; 'Permissions' = $Access.FileSystemRights; 'Inherited' = $Access.IsInherited }
        New-Object -TypeName PSObject -Property $Properties
    } 
}
Write-Host ""

# Permissions of folders
$FolderPath = Get-ChildItem -Directory -Path "C:\TEMP" -Recurse -Force
$Output = @()
ForEach ($Folder in $FolderPath) {
    $Acl = Get-Acl -Path $Folder.FullName
    ForEach ($Access in $Acl.Access) {
        $Properties = [ordered]@{'Folder Name' = $Folder.FullName; 'Group/User' = $Access.IdentityReference; 'Permissions' = $Access.FileSystemRights; 'Inherited' = $Access.IsInherited }
        $Output += New-Object -TypeName PSObject -Property $Properties            
    }
}
$Output | Out-GridView

# The above output only lists folders. There are no files in the results.
# To see files create an array ($Output) and pipe the results to Out-GridView or a .csv file.

# Output as a CSV
$BaseFolder = "C:\INSTALL"
Write-Host "BaseFolder="$BaseFolder
$FolderPath = Get-ChildItem -Directory -Path $BaseFolder -Recurse -Force
$Output = @()
$Acl = Get-Acl -Path $BaseFolder
ForEach ($Access in $Acl.Access) {
    $Properties = [ordered]@{'Folder Name' = $BaseFolder; 'Group/User' = $Access.IdentityReference; 'Permissions' = $Access.FileSystemRights; 'Inherited' = $Access.IsInherited }
    $Output += New-Object -TypeName PSObject -Property $Properties
}
ForEach ($Folder in $FolderPath) {
    $Acl = Get-Acl -Path $Folder.FullName
    ForEach ($Access in $Acl.Access) {
        $Properties = [ordered]@{'Folder Name' = $Folder.FullName; 'Group/User' = $Access.IdentityReference; 'Permissions' = $Access.FileSystemRights; 'Inherited' = $Access.IsInherited }
        $Output += New-Object -TypeName PSObject -Property $Properties       
    }
}
$Output | Export-Csv "C:\TEMP\Folder-Permissions-TEMP.csv"
