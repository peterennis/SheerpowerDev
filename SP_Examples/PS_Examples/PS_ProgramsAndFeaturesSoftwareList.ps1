# Ref: http://social.technet.microsoft.com/Forums/windowsserver/en-US/1fd035f3-a170-4721-a6b5-d4809ca2e39d/getting-list-of-installed-software-that-matches-control-panels-addremove-programs-or-programs

Clear-Host

Set-Location C:\TEMP

$comp = $args[0]
    
if (($comp -eq "/?") -or ($comp -eq "-h")) {
    (Get-Content C:\$env:HOMEPATH\get-prog-help.txt) | Write-Host
}  
else { 
    if ($comp -lt 1) {
        Write-Host -fore Green "======= Uninstall regkey ======="
        Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*' | `
            Where-Object { $_.DisplayName } | Select-Object DisplayName, DisplayVersion, Publisher | `
            Sort-Object DisplayName | Format-Table -AutoSize 
        Write-Host -fore Green "======= Wow6432Node Uninstall regkey ======="
        Get-ItemProperty 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*' | `
            Where-Object { $_.DisplayName } | Select-Object DisplayName, DisplayVersion, Publisher | `
            Sort-Object DisplayName | `
            Format-Table -AutoSize
    }  
    else {
        $computername = $comp
        $code = { Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*' | `
                Where-Object { $_.DisplayName } | Select-Object DisplayName, DisplayVersion, Publisher | `
                Sort-Object DisplayName | `
                Format-Table -AutoSize
            Get-ItemProperty 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*' | `
                Where-Object { $_.DisplayName } | `
                Select-Object DisplayName, DisplayVersion, Publisher | `
                Sort-Object DisplayName | `
                Format-Table -AutoSize }
        Invoke-Command -ComputerName $computername -ScriptBlock $code
    } 
}
pause