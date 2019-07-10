# Ref: http://blogs.technet.com/b/heyscriptingguy/archive/2011/11/13/use-powershell-to-quickly-find-installed-software.aspx

# Get-ExecutionPolicy 
# The command shows the current script execution policy
# Ref: http://technet.microsoft.com/library/hh847748.aspx
# Ref: http://technet.microsoft.com/en-us/library/hh849812.aspx
# Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted
# The command uses the Set-ExecutionPolicy cmdlet to set an execution policy of Unrestricted for the current user.

Clear-Host

Write-Host "Start=>"
# Ref: https://social.technet.microsoft.com/wiki/contents/articles/7703.powershell-running-executables.aspx

$PATH = 'C:\SysinternalsSuite\'
$CMD = $PATH + 'accesschk.exe'
$arg1 = 'W:'
 
& $CMD $arg1
 
Write-Host "<=End"