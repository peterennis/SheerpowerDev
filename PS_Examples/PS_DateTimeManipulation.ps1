# Ref: https://www.youtube.com/watch?v=YQn7zgwlG40

# Ref: http://blogs.technet.com/b/heyscriptingguy/archive/2011/11/13/use-powershell-to-quickly-find-installed-software.aspx

# Get-ExecutionPolicy 
# The command shows the current script execution policy
# Ref: http://technet.microsoft.com/library/hh847748.aspx
# Ref: http://technet.microsoft.com/en-us/library/hh849812.aspx
# Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted
# The command uses the Set-ExecutionPolicy cmdlet to set an execution policy of Unrestricted for the current user.

<#
Clear-Host
Write-Host "Start=>" -BackgroundColor Magenta

$MyDate = Get-Date
$MyDate

$MyDate | Select-Object * 

$MyDate.DayOfWeek
$MyDate.Month

$MyDate | Get-Member | Format-Table -Wrap

$MyDate.ToShortDateString()
$MyDate.ToLongDateString()
$MyDate.ToLongTimeString()
$MyDate.AddMonths(4)
$MyDate.AddMonths(-4)

$AnOlderDate = $MyDate.AddMonths(-6)
$AnOlderDate

(Get-Date).AddMonths(2)

Get-EventLog System -After (Get-Date).AddMinutes(-1000)

$newDate = "6/3/2000 5:00 PM"
$newDate
# newDate is stored as string!
$newDate | Get-Member


$betterDate = Get-Date "6/10/2000 5:00 PM"
$betterDate
# betterDate is stored as date!
#$betterDate | Get-Member | Format-Table -Wrap

Get-Date $betterDate -Format MMMM
Get-Date $betterDate -Format MMM
Get-Date $betterDate -Format MM
Get-Date $betterDate -Format d
Get-Date $betterDate -Format dd
Get-Date $betterDate -Format dddd
Get-Date $betterDate -Format "MMMM dd, yyyy"
Get-Date $betterDate -Format "M.d.yy"
Get-Date $betterDate -UFormat %j
#>

$myFile = Get-Item  C:\PETER\PDF\OptimizingCloud.pdf
$myFile
#$myFile | Select-Object *

$myFile.CreationTime







Write-Host "<=End" -BackgroundColor Magenta
