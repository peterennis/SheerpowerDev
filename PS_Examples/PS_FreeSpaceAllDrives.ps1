Get-PSDrive | Where-Object { $_.Free -gt 1 } | `
    ForEach-Object { $Count = 0; Write-Host ""; } `
    { $_.Name + `
    ": Used :" + "{0:N2}" -f ($_.Used / 1Gb) + `
    " Free: " + "{0:N2}" -f ($_.Free / 1Gb) + `
    " Total: " + "{0:N2}" -f (($_.Used / 1Gb) + ($_.Free / 1Gb)); `
    $Count = $Count + $_.Free; }`
    { Write-Host ""; Write-Host `
    "Total Free Space " ("{0:N2}" -f ($Count / 1Gb)) `
    -backgroundcolor magenta }


    Get-Volume
