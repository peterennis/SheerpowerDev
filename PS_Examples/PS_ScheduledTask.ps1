Clear-Host
Write-Host "Start=>" -BackgroundColor Magenta

$demoScript = 'C:\RDAVSTS\SheerpowerDev\PS_Examples\PS_ScheduledTaskDemoScript.ps1'

$action = New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument $demoScript

$trigger = New-ScheduledTaskTrigger -Daily -At 10am

Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "PS Task Demo" -Description "Running the PowerShell task demo"

Write-Host "<=End" -BackgroundColor Magenta
