<##############################################################################
Author: Peter Geelen
Quest For Security 
October 2016 http://identityunderground.wordpress.com
This script finds all AD objects protected by accidental deletions.
Credits: This script uses logic that has been developed by:
- Ashley McGlone, Microsoft Premier Field Engineer, March 2013, http://aka.ms/GoateePFE 
- Source: https://gallery.technet.microsoft.com/Active-Directory-OU-1d09f989
LEGAL DISCLAIMER
This Sample Code is provided for the purpose of illustration only and is not intended to be used in a production environment.
THIS SAMPLE CODE AND ANY RELATED INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, 
INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE.  
We grant You a nonexclusive, royalty-free right to use and modify the Sample Code and to reproduce and distribute the object code form of the Sample Code, 
provided that You agree: 
(i) to not use Our name, logo, or trademarks to market Your software product in which the Sample Code is embedded; 
(ii) to include a valid copyright notice on Your software product in which the Sample Code is embedded;and 
(iii) to indemnify, hold harmless, and defend Us and Our suppliers from and against any claims or lawsuits, including attorneys  fees, that arise or result from the use or distribution of the Sample Code.

This posting is provided "AS IS" with no warranties, and confers no rights. Use of included script samples are subject to the terms specified at http://www.microsoft.com/info/cpyright.htm.
##############################################################################>

#-----------------------------------------------------------------------------
# Source references
#-----------------------------------------------------------------------------

# Preventing Unwanted/Accidental deletions and Restore deleted objects in Active Directory
# abizer_hazratJune 9, 2009
# https://blogs.technet.microsoft.com/abizerh/2009/06/09/preventing-unwantedaccidental-deletions-and-restore-deleted-objects-in-active-directory/
# Windows Server 2008 Protection from Accidental Deletion
# James ONeill, October 31, 2007
# https://blogs.technet.microsoft.com/industry_insiders/2007/10/31/windows-server-2008-protection-from-accidental-deletion/

#-----------------------------------------------------------------------------
# Prerequisites: 
# this script only runs if you can load the AD PS module
# eg. run the analysis on a DC
#-----------------------------------------------------------------------------

Clear-Host

import-module activedirectory

#-----------------------------------------------------------------------------
# initialisation
#-----------------------------------------------------------------------------

# the CSV file is saved in the same directory as the PS file
$csvFile = $MyInvocation.MyCommand.Definition -replace 'ps1', 'csv'
$report = @()

# (*) Credits 

$schemaIDGUID = @{ }

### NEED TO RECONCILE THE CONFLICTS ###

$ErrorActionPreference = 'SilentlyContinue'

Get-ADObject -SearchBase (Get-ADRootDSE).schemaNamingContext -LDAPFilter '(schemaIDGUID=*)' -Properties name, schemaIDGUID |
ForEach-Object { $schemaIDGUID.add([System.GUID]$_.schemaIDGUID, $_.name) }

Get-ADObject -SearchBase "CN=Extended-Rights,$((Get-ADRootDSE).configurationNamingContext)" -LDAPFilter '(objectClass=controlAccessRight)' -Properties name, rightsGUID |
ForEach-Object { $schemaIDGUID.add([System.GUID]$_.rightsGUID, $_.name) }

$ErrorActionPreference = 'Continue'

# (*)

#-----------------------------------------------------------------------------
#Functions
#-----------------------------------------------------------------------------

function CheckProtection {
    param($obj)
    $path = "AD:\" + $obj
    Get-Acl -Path $path | `
        Select-Object -ExpandProperty Access | `
        Where-Object { ($_.ActiveDirectoryRights -like "*DeleteTree*") -AND ($_.AccessControlType -eq "Deny") } | `

    #(*)
    Select-Object @{name = 'Object'; expression = { $obj } }, `
    @{name = 'objectTypeName'; expression = { if ($_.objectType.ToString() -eq '00000000-0000-0000-0000-000000000000') { 'All' } Else { $schemaIDGUID.Item($_.objectType) } } }, `
    @{name = 'inheritedObjectTypeName'; expression = { $schemaIDGUID.Item($_.inheritedObjectType) } }, `

    #(*)
    ActiveDirectoryRights,
    ObjectFlags,
    AccessControlType,
    IdentityReference,
    IsInherited,
    InheritanceFlags,
    PropagationFlags
}

#-----------------------------------------------------------------------------
# MAIN
#-----------------------------------------------------------------------------

# add the top domain
$OUs = @(Get-ADDomain | Select-Object -ExpandProperty DistinguishedName)
Write-Host "Top Domain OUs:"$OUs

# add the OUs
$OUs += Get-ADOrganizationalUnit -Filter * | Select-Object -ExpandProperty DistinguishedName

# add other containers
##$OUs += Get-ADObject -SearchBase (Get-ADDomain).DistinguishedName -LDAPFilter '(|(objectClass=container)(objectClass=builtinDomain))' | Select-Object -ExpandProperty DistinguishedName

# if you don't want to scan the builtin container use line below instead of line above
$OUs += Get-ADObject -SearchBase (Get-ADDomain).DistinguishedName -LDAPFilter '(objectClass=container)' | Select-Object -ExpandProperty DistinguishedName

# set the target objects types to investigate
# including users, groups, contacts, computers
$ldapfilter = '(|(objectclass=user)(objectclass=group)(objectclass=contact)(objectclass=computer))'

#$ldapfilter = '(|(objectclass=user)(objectclass=group)(objectclass=contact)(objectclass=computer)(objectclass=Foreign-Security-Principal))'

# not included: Foreign-Security-Principal, msTPM-InformationObjectsContainer, msDS-QuotaContainer, lostAndFound,

$iSeqNo = 0

$OUCount = $OUs.Count
Write-Host "OUCount ="$OUCount

ForEach ($OU in $OUs) {
    $iSeqNo++
    $pct = ([int]($iSeqNo / $OUCount * 100))
    $activity = "Analyzing container: " + $OU
    Write-Progress -activity $activity -status "Please wait" -percentcomplete $pct -currentoperation "now processing container $iSeqNo of $OUCount" -id 1

    # check the protection of the parent container
    $isProtected = ''
    $isProtected = CheckProtection $OU
    if ($null -ne $isProtected) { $report += $isProtected }

    # Lookup the child target objects in the parent container
    $objects = Get-ADObject -SearchBase $OU -SearchScope OneLevel -LDAPFilter $ldapfilter | Select-Object -ExpandProperty DistinguishedName
    $iSubSeqNo = 0
    $ObjCount = $objects.Count

    # check the protection of the child objects
    ForEach ($object in $objects) {
        $iSubSeqNo++
        $iSubpct = ([int]($iSubSeqNo / $ObjCount * 100))
        $SubActivity = "Analyzing object: " + $object 
        Write-Progress -activity $SubActivity -status "Please wait" -percentcomplete $iSubpct -currentoperation "now processing object $iSubSeqNo of $ObjCount" -ParentId 1 -id 2

        $isProtected = ''
        $isProtected = CheckProtection $object
        if ($null -ne $isProtected) { $report += $isProtected }
    }

    Write-Progress -activity "Analyzing object completed." -status "Proceeding" -Completed -ParentId 1 -id 2
}
Write-Host "Loop completed!"

$report | Format-Table -Wrap

$report | Export-Csv -Path $csvFile -NoTypeInformation