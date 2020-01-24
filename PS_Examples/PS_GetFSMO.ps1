# This is the PowerShell equivalent for
# netdom query fsmo

Get-ADForest |`
    Select-Object SchemaMaster, DomainNamingMaster |`
    Format-List
Get-ADDomain |`
    Select-Object PDCEmulator, RIDMaster, InfrastructureMaster |`
    Format-List
