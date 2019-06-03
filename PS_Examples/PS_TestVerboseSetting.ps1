<#
    Get-Verbose - determine if the Cmdlet flag -Verbose is set.
    Ref: http://www.mobzystems.com/blog/getting-the-verbose-switch-setting-in-powershell/
#>
[Cmdletbinding()]
Param()
 
# Write the string "TEST" to the verbose output stream,
# but redirect that to standard output using 4>&1.
$verbose = (!!(Write-Verbose "" 4>&1))

Write-Output $("The value of `$verbose` is " + $verbose)
