# Run the following command first in the console to bypass not digitally signed error
# Ref: http://tritoneco.com/2014/02/21/fix-for-powershell-script-not-digitally-signed/
# Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

$outputfiletxt = "C:\TEMP\My File System Report.txt"
$outputfileperformancetxt = "C:\TEMP\My File System Report TXT Performance.txt"
$outputfilecsv = "C:\TEMP\My File System Report.csv"
$outputfileperformancecsv = "C:\TEMP\My File System Report CSV Performance.txt"
#$mydir = "C:\Windows"
#$mydir = "C:\INSTALL"
#$mydir = "C:\SARA.github"
$mydir = "C:\AndroidStudio"

if (Test-Path $mydir) {
    #throw $mydir + " exists."
}
else {
    # Exit if $mydir does NOT exist
    throw $mydir + " does NOT exist."
    Exit
}



# Get-ChildItem          ' alias is gci
# Get-Alias | More       ' show paged list of all aliases
#
# Show all aliases for Get-ChildItem
# Ref: https://stackoverflow.com/questions/6635059/filter-the-output-of-a-command-as-if-it-was-text
# (Get-Alias | Out-String) -split "`r`n" | Select-String Get-ChildItem

# Show all properties of Get-ChildItem
# NOTE: The available properties are not of the cmdlet, but of the objects it produces
# Ref: https://www.vistax64.com/threads/how-do-i-find-the-available-properties-say-of-get-childitem.47251/
# Get-ChildItem | Get-Member

# NOTE: Generally, the closer you can get to limiting the number of objects returned to the pipeline, the faster you code will run
# Ref: https://mcpmag.com/articles/2018/01/16/filtering-command-output-in-powershell.aspx
# Using Filter is 4x faster than Where-Object and 3x faster than where() !!!

# ALL properties for Get-ChildItem
# TEST 1
# Attributes, BaseName, CreationTime, Directory, DirectoryName, Exists, Extension, FullName, IsReadOnly, LastAccessTime, Length, LinkType, Mode, Name, Parent, PSStandardMembers, Root, Target, VersionInfo |
# RESULTS: Latitude E6430 : My File System Report.txt -> 555,569 KB : My File System Report.csv -> 181,384 KB
# TEST 2 - Do not extport VersionInfo
# Attributes, BaseName, CreationTime, Directory, DirectoryName, Exists, Extension, FullName, IsReadOnly, LastAccessTime, Length, LinkType, Mode, Name, Parent, PSStandardMembers, Root, Target |


# NOTE: Cannot use Format-Table as the output will be truncated
# Performance:
# Ref: https://4sysops.com/archives/measure-the-run-time-of-a-powershell-command-with-measure-command/
# Ref: https://www.pluralsight.com/blog/tutorials/measure-powershell-scripts-speed


Measure-Command -Expression {Get-ChildItem -Force $mydir -Recurse |
        Select-Object Attributes, BaseName, CreationTime, Directory, DirectoryName, Extension, FullName, IsReadOnly, LastAccessTime, Length, LinkType, Mode, Name, Parent, PSStandardMembers, Root, Target |
        Sort-Object -Property Length -Descending > $outputfiletxt} > $outputfileperformancetxt

#Write-Host "Result sent to '$outputfiletxt'"
#Read-Host -Prompt "Press Enter to continue"

Measure-Command -Expression {Get-ChildItem -Force $mydir -Recurse |
        Select-Object Attributes, BaseName, CreationTime, Directory, DirectoryName, Extension, FullName, IsReadOnly, LastAccessTime, Length, LinkType, Mode, Name, Parent, PSStandardMembers, Root, Target |
        Sort-Object -Property Length -Descending |
        Export-Csv $outputfilecsv -NoTypeInformation } > $outputfileperformancecsv
