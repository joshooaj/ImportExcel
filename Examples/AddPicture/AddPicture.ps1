function Set-ExcelPicture {
    param(
        [System.Drawing.Image]$Image,
        $WorkSheet,
        $Row,
        $Column,
        [Switch]$AdjustCellDimensions
    )

    $picture = $WorkSheet.Drawings.AddPicture('name', $Image)

    $picture.SetPosition($row - 1, 0, $Column - 1, 0)

    $targetHeight = $Image.Height * (375 / 500)
    $targetWidth = $Image.Width * (17 / 120)

    if ($AdjustCellDimensions) {
        if ($WorkSheet.Row($row).Height -lt $targetHeight) {
            $WorkSheet.Row($row).Height = $targetHeight
        }
        if ($WorkSheet.Column($Column).Width -lt $targetWidth) {
            $WorkSheet.Column($Column).Width = $targetWidth
        }
    }
}

$data = ConvertFrom-Csv @"
Region,State,Units,Price
West,Texas,927,923.71
North,Tennessee,466,770.67
East,Florida,520,458.68
East,Maine,828,661.24
West,Virginia,465,053.58
North,Missouri,436,235.67
South,Kansas,214,992.47
North,North Dakota,789,640.72
South,Delaware,712,508.55
"@

Remove-Item ./testPic.xlsx -ErrorAction SilentlyContinue

$xlpkg = $data | Export-Excel -Path ./testPic.xlsx -PassThru

$file = '.\Octocat.jpg'
$v = [System.Drawing.Image]::FromFile($file)

$ws = $xlpkg.Sheet1

Set-ExcelPicture -Image $v -WorkSheet $ws -Row 4 -Column 6 -AdjustCellDimensions

Close-ExcelPackage $xlpkg -Show