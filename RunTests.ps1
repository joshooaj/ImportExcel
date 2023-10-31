#Requires -Modules @{ ModuleName = 'Pester'; ModuleVersion = '5.1.0' }
param(
    [Parameter()]
    [string]
    $ModulePath,

    [Parameter()]
    [switch]
    $NoIsolation
)

if ([string]::IsNullOrEmpty($ModulePath)) {
    $ModulePath = (.$PSScriptRoot/build.ps1).Output.ManifestPath
}

if ($NoIsolation) {
    $configuration = [PesterConfiguration]@{
        Run    = @{
            PassThru  = $true
            Container = New-PesterContainer -Path '__tests__/' -Data @{ 
                ModulePath = $ModulePath
            }
        }
        Output = @{
            Verbosity = 'Detailed'
        }
    }
    
    $testResult = Invoke-Pester -Configuration $configuration
    
    if ($testResult.FailedCount -or -not $testResult.PassedCount) {
        exit 1
    }
} else {
    $cmd = (Get-Process -Id $PID).ProcessName
    $scriptPath = Join-Path -Path $PWD -ChildPath $MyInvocation.MyCommand.Name
    $command = ".'$scriptPath' -ModulePath '$ModulePath' -NoIsolation"
    & $cmd -NoLogo -NoProfile -ExecutionPolicy Bypass -WorkingDirectory "$PWD" -Command $command
    exit $LASTEXITCODE
}
