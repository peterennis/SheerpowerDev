<#
    Get-Verbose - determine if the Cmdlet flag -Verbose is set.
    Ref: http://www.mobzystems.com/blog/getting-the-verbose-switch-setting-in-powershell/
#>
[Cmdletbinding()]
Param()
 
# Write the string "TEST" to the verbose output stream,
# but redirect that to standard output using 4>&1
$verbose = (!!(Write-Verbose "" 4>&1))

Write-Output $(">> The value of `$verbose` is " + $verbose)

# Ref: https://virtuallyjason.blogspot.com/2014/03/powershell-sorting-by-multiple-columns.html
$adapter_list = "ListOfVMnetworkAdapters.txt"
Write-Output $(">> Writing the list of VM network adapters to " + $adapter_list + " sorted by VMNAME,SwitchName")

$myData = Get-VMNetworkAdapter -VMName * | sort VMNAME,SwitchName  > $adapter_list

type $adapter_list
