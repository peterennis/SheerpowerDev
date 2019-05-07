# Ref: https://blogs.technet.microsoft.com/heyscriptingguy/2018/09/15/using-powershell-to-create-a-folder-of-demo-data/

# Provide Folder name and create it
$Folder = 'C:\SP_Demo_Data'

New-Item -ItemType Directory -Path $Folder

# Create a series of 10 files
for ($x = 0; $x -lt 10; $x++) {
    # Let's create a completely random filename
    $filename = "$($Folder)\Logfile$((Get-Random 100000).tostring()).txt"

    # Now we'll create the file with some content
    # We're going to build files up to 1K in size

    $limit = (Get-random 1024)

    # Let's build the random content
    for ($y = 0; $y -lt $limit; $y++) {

        # We're building a content of pure ASCII data
        $a = $a + [char][byte]((Get-Random 64) + 32)
    }

    $DaysToMove = ((Get-Random 120) - 60)
    $HoursToMove = ((Get-Random 48) - 24)
    $MinutesToMove = ((Get-Random 120) - 60)
    $TimeSpan = New-TimeSpan -Days $DaysToMove -Hours $HoursToMove -Minutes $MinutesToMove

    # Now we adjust the Date and Time by the new TimeSpan
    # Needs Admin rights to do this as well!

    Set-Date -Adjust $Timespan | Out-Null

    # Create the file
    Add-Content -Value $a -Path $filename

    # Now we REVERSE the Timespan by the exact same amount
    $TimeSpan = New-TimeSpan -Days (-$DaysToMove) -Hours (-$HoursToMove) -Minutes (-$MinutesToMove)

    Set-Date -Adjust ($Timespan) | Out-Null

}