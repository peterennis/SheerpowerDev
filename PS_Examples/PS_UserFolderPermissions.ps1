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

### Show all properties of Get-Acl in a list
#Get-Acl -Path C:\Peter | Format-List -Property *

# Generate a report on a user folder and output as csv
# Ref: https://social.technet.microsoft.com/wiki/contents/articles/51422.how-to-export-folder-permissions-to-excel-or-csv-file.aspx
# The following fails due to ItemNotFoundException for path tool long (node_modules)
<#
$Report = @()
Foreach ($Folder in $FolderPath) {
    $Acl = Get-Acl -Path $Folder.FullName
    foreach ($Access in $acl.Access) {
        $Properties = [ordered]@{'FolderName' = $Folder.FullName; `
                'AD Group or User'            = $Access.IdentityReference; `
                'Permissions'                 = $Access.FileSystemRights; `
                'Inherited'                   = $Access.IsInherited
        }
        $Report += New-Object -TypeName PSObject -Property $Properties
    }
}
$Report | Export-Csv -Path "C:\TEMP\User-Folder-Permissions-TEMP.csv"
#>


# Generate a report on a user folder and output as csv
# Ref: https://community.spiceworks.com/topic/1529112-path-too-long-error - ignores the errors
$OutFile = "C:\TEMP\MyOutfile.txt"
$Folders = Get-ChildItem $RootPath -recurse -Directory -ErrorAction SilentlyContinue
#Turns out we don't need to do any error checking. The folder will continue to be scanned even if it hits a PathTooLongException

$Total = ($Folders | Measure-Object).count
$Current = 0

foreach ($Folder in $Folders) {
    $Current++
    Write-Progress -Activity "Getting Access Control List" -Status "Working on $Current / $Total" -PercentComplete (($Current / $Total) * 100)
    $ACLs = Get-Acl $Folder.fullname -ErrorAction SilentlyContinue -ErrorVariable AccessDenied | ForEach-Object { $_.Access }
    $Owner = Get-Acl $Folder.FullName -ErrorAction SilentlyContinue -ErrorVariable AccessDenied | ForEach-Object { $_.Owner }

    Foreach ($ACL in $ACLs) {
        $OutInfo = ($Folder.Fullname).replace(',', '<comma-removed>') + "," + $ACL.IdentityReference + "," + $ACL.AccessControlType + "," + (((($ACL.FileSystemRights) | Out-String).Replace(",", "/")).Replace("`r`n", "")) + "," + $ACL.IsInherited + "," + $Owner + "," + $ACL.PropagationFlags + "," + $ACL.InheritanceFlags
        Add-Content -Value $OutInfo -Path $OutFile
    }    
}


Write-Host "<=End"
