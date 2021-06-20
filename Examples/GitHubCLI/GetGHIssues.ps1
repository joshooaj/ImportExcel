function Get-GHIssues {
    param (
        $repo = 'dfinke/importexcel',
        $limit = 30
    )
    
    $result = ConvertFrom-Json (gh issue list -s all -L $limit -R $repo --json 'author,number,createdAt,closedAt,updatedAt,state,title,url')

    foreach ($item in $result) {    
        [PSCustomObject][Ordered] @{
            repo    = $repo
            author  = $item.author.login
            number  = $item.number
            created = $item.createdAt
            updated = $item.updatedAt
            closed  = !$item.closedAt ? 'n/a' : $item.closedAt
            state   = $item.state
            title   = $item.title
            url     = $item.url
        }   
    }
}

$xlparams = @{
    AutoFilter        = $true
    AutoNameRange     = $true
    AutoSize          = $true
    IncludePivotChart = $true
    IncludePivotTable = $true
    Path              = './ghissues.xlsx'    
    PivotChartType    = 'PieExploded3D'
    PivotData         = @{"state" = "count" }
    PivotRows         = 'state' 
    Show              = $true
    TableName         = 'ghIssues'
    WorksheetName     = 'ghIssues'
}

$repo = 'dfinke/importexcel'
Remove-Item ./ghissues.xlsx -ErrorAction silentlycontinue
Get-GHIssues $repo -limit 100 | Export-Excel @xlparams