# Ref: https://sketchingdev.co.uk/blog/powershell-extract-the-summary-table-from-robocopys-log-file.html

$robocopylog = "..\assets\robocopy-sample-output-result.log"

function Select-RoboSummary {
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [string]$log,
        [parameter(Mandatory=$false,ValueFromPipeline=$false)]
        [switch]$separateUnits
    )
    PROCESS
    {
        $cellHeaders = @("Total", "Copied", "Skipped", "Mismatch", "Failed", "Extras")
        $rowTypes    = @("Dirs", "Files", "Bytes")

        # Extract rows
        $rows = $log | Select-String -Pattern "(Dirs|Files|Bytes)\s*:(\s*([0-9]+(\.[0-9]+)?( [a-zA-Z]+)?)+)+" -AllMatches
        if ($rows.Count -eq 0)
        {
            throw "Summary table not found"
        }

        if ($rows.Matches.Count -ne $rowTypes.Count)
        {
            throw "Unexpected number of rows/ Expected {0}, found {1}" -f $rowTypes.Count, $rowsMatch.Count
        }

        # Merge each row with its corresponding row type, with property names of the cell headers
        for($x = 0; $x -lt $rows.Matches.Count; $x++)
        {
            $rowType  = $rowTypes[$x]
            $rowCells = $rows.Matches[$x].Groups[2].Captures | ForEach-Object{ $_.ToString().Trim() }

            if ($cellHeaders.Length -ne $rowCells.Count)
            {
                throw "Unexpected amount of cells in a row. Expected {0} cells (the amount of headers) but found {1}" -f $cellHeaders.Length,$rowCells.Count
            }

            $row = New-Object -TypeName PSObject
            $row | Add-Member -Type NoteProperty Type($rowType)

            for($i = 0; $i -lt $rowCells.Count; $i++)
            {
                $header = $cellHeaders[$i]
                $cell   = $rowCells[$i]

                if ($separateUnits -and ($cell -match " "))
                {
                    $cell = $cell -split " "
                }

                $row | Add-Member -Type NoteProperty -Name $header -Value $cell
            }
            $row
        }
    }
}

Get-Content $robocopylog -Raw | Select-RoboSummary | Sort-Object Type | Format-Table

