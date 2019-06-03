# Run the following command first in the console to bypass not digitally signed error
# Ref: http://tritoneco.com/2014/02/21/fix-for-powershell-script-not-digitally-signed/
# Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass


# Windows 10 and Windows Server 2016 PowerShell - Get GPO Reports
# Run as administrator on the DC
# Ref: https://docs.microsoft.com/en-us/powershell/module/grouppolicy/get-gporeport?view=win10-ps
Get-GPOReport -All -Domain "domain.local" -Server "THEDC" -ReportType XML -Path "C:\GPOReports\GPOReportsAll.xml"

