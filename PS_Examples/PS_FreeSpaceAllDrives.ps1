# Ref: https://www.youtube.com/watch?v=f9xPJXslVWE
Get-PSDrive | Where-Object { $_.Free -gt 1 } | `
    ForEach-Object { $Count = 0; Write-Host "This is output once at the start"; } { $_.Name + ": Used :" + "{0:N2}" -f ($_.Used / 1Gb) + `
        " Free: " + "{0:N2}" -f ($_.Free / 1Gb) + " Total: " + "{0:N2}" -f (($_.Used / 1Gb) + ($_.Free / 1Gb)); `
        $Count = $Count + $_.Free; } { Write-Host ""; Write-Host "This is written once at the end - " `
        "Total Free Space " ("{0:N2}" -f ($Count / 1Gb)) -BackgroundColor Magenta }


Get-Volume
