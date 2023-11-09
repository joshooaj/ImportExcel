Describe 'Invoke-ScriptAnalyzer' {
    It 'PSScriptAnalyzer shows no warnings' {
        $results = Invoke-ScriptAnalyzer -Path $PSScriptRoot/../ImportExcel -Settings PSGallery -Recurse
        $location = @{
            Name       = 'Location'
            Expression = {
                '{0}:{1}:{2}' -f (Resolve-Path -Path $_.ScriptPath -Relative), $_.Line, $_.Column
            }
        }
        $table = $results | Where-Object Severity -gt 0 | Select-Object RuleName, $location, Message | Format-Table -Wrap | Out-String
        $table | Should -BeNullOrEmpty
    }
}