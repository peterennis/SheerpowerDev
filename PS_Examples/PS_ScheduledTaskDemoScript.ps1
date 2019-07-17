# Output date and drive info to a log file
Get-Date | Out-File C:\TEMP\tasklog.txt -Append
Get-PSDrive -PSProvider FileSystem | Out-File C:\TEMP\tasklog.txt -Append
