Import-Module .\ImportExcel.psd1 -force

$xlfile = "$env:TEMP\test.xlsx"
Remove-Item $xlfile -ErrorAction SilentlyContinue

$data = ConvertFrom-Csv @"
Region,ItemName,TotalSold
South,nail,77
North,lime,46
East,saw,40
East,kiwi,42
North,banana,97
East,pear,29
South,peach,28
East,pear,30
South,pear,52
East,kiwi,23
"@

$params = @{
    Path      = $xlfile 
    Title     = "Hello from PowerShell - EPPlus 5.0" 
    Show      = $true
    AutoSize  = $true
    TableName = 'MyTable'
}

Export-Excel -InputObject $data @params


