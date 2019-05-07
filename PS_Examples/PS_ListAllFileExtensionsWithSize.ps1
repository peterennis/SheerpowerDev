# Ref: https://social.technet.microsoft.com/Forums/en-US/814fed50-2d03-45d0-a44d-0fe14a3a855d/list-all-file-extensions-with-size?forum=winserverpowershell

# Run the following command first in the console to bypass not digitally signed error
# Ref: http://tritoneco.com/2014/02/21/fix-for-powershell-script-not-digitally-signed/
# Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

$outputfiletxt = "C:\TEMP\The Format Table.txt"
$outputfilecsv = "C:\TEMP\The Format Table.csv"

#$dir = "."
#$dir = "C:\Windows"
#$dir = "C:\INSTALL"
$dir = "C:\SARA.github"

if (Test-Path $dir) {
    #throw $dir + " exists."
}
else {
    # Exit if $dir does NOT exist
    throw $dir + " does NOT exist."
    Exit
}


$count = @{}
$size = @{}
Get-ChildItem $dir -recurse | ForEach-Object {
    [int]$count[$_.extension] += 1
    [int64]$size[$_.extension] += $_.length
}
$final_results = @()
$count.keys | ForEach-Object {
    $result = "" | Select-Object extension, extensionLength, count, size
    $result.extension = $_
    $result.extensionLength = $_.length
    $result.count = $count[$_]
    $result.size = $size[$_]
    $final_results += $result
}
$final_results | Sort-Object -Property extensionLength -Descending |
    Format-Table -AutoSize > $outputfiletxt

$final_results | Sort-Object -Property extensionLength -Descending |
    Export-Csv $outputfilecsv -NoTypeInformation
