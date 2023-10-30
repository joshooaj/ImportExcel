#region import everything we need
Import-LocalizedData -BindingVariable 'Strings' -FileName 'strings' -BaseDirectory "$PSScriptRoot/Localized"
try { [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") }
catch { Write-Warning -Message $Strings.SystemDrawingAvailable }

foreach ($directory in @('Private', 'Public', 'Charting', 'InferData', 'Pivot')) {
    Get-ChildItem -Path "$PSScriptRoot\$directory\*.ps1" | ForEach-Object { . $_.FullName }
}

if ($PSVersionTable.PSVersion.Major -ge 5) {
    . $PSScriptRoot\Plot.ps1

    function New-Plot {
        [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingfunctions', '', Justification = 'New-Plot does not change system state')]
        param()

        [PSPlot]::new()
    }

}
else {
    Write-Warning $Strings.PS5NeededForPlot
    Write-Warning $Strings.ModuleReadyExceptPlot
}

#endregion

if (($IsLinux -or $IsMacOS) -or $env:NoAutoSize) {
    $ExcelPackage = [OfficeOpenXml.ExcelPackage]::new()
    $Cells = ($ExcelPackage | Add-Worksheet).Cells['A1']
    $Cells.Value = 'Test'
    try {
        $Cells.AutoFitColumns()
        if ($env:NoAutoSize) { Remove-Item Env:\NoAutoSize }
    }
    catch {
        $env:NoAutoSize = $true
        if ($IsLinux) {
            Write-Warning -Message $Strings.NoAutoSizeLinux
        }
        if ($IsMacOS) {
            Write-Warning -Message $Strings.NoAutoSizeMacOS
        }
    }
    finally {
        $ExcelPackage | Close-ExcelPackage -NoSave
    }
}
