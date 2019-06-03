# Ref: http://blogs.technet.com/b/heyscriptingguy/archive/2011/11/13/use-powershell-to-quickly-find-installed-software.aspx

# Get-ExecutionPolicy 
# The command shows the current script execution policy
# Ref: http://technet.microsoft.com/library/hh847748.aspx
# Ref: http://technet.microsoft.com/en-us/library/hh849812.aspx
# Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted
# The command uses the Set-ExecutionPolicy cmdlet to set an execution policy of Unrestricted for the current user.

cls

Write-Host "Start=>"

# NOTE: computers is the header name in the csv file

$computers = Import-Csv "C:\ae\computerlist.csv"

Write-Host $computers

$array = @()

foreach($pc in $computers){

    $computername=$pc.computername

    Write-Host -fore Green "The Computer Name=======$computername======="
    Write-Host -fore Red "The PC=======$pc======="

    #Define the variable to hold the location of Currently Installed Programs

    $UninstallKey="SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall" 

    #Create an instance of the Registry Object and open the HKLM base key

    $reg=[microsoft.win32.registrykey]::OpenRemoteBaseKey('LocalMachine',$computername) 

    #Drill down into the Uninstall key using the OpenSubKey Method

    $regkey=$reg.OpenSubKey($UninstallKey) 

    #Retrieve an array of string that contain all the subkey names

    $subkeys=$regkey.GetSubKeyNames() 

    #Open each Subkey and use GetValue Method to return the required values for each

    foreach($key in $subkeys){

        $thisKey=$UninstallKey+"\\"+$key 

        $thisSubKey=$reg.OpenSubKey($thisKey) 

        $obj = New-Object PSObject

        $obj | Add-Member -MemberType NoteProperty -Name "ComputerName" -Value $computername

        $obj | Add-Member -MemberType NoteProperty -Name "DisplayName" -Value $($thisSubKey.GetValue("DisplayName"))

        $obj | Add-Member -MemberType NoteProperty -Name "DisplayVersion" -Value $($thisSubKey.GetValue("DisplayVersion"))

        $obj | Add-Member -MemberType NoteProperty -Name "InstallLocation" -Value $($thisSubKey.GetValue("InstallLocation"))

        $obj | Add-Member -MemberType NoteProperty -Name "Publisher" -Value $($thisSubKey.GetValue("Publisher"))

        $array += $obj

    } 

}

$array | Where-Object { $_.DisplayName } | select ComputerName, DisplayName, DisplayVersion, Publisher | ft -auto