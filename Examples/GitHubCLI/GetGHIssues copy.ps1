function Get-GHIssues {
    param (
        $repo = 'dfinke/importexcel',
        $limit = 30
    )

    # $result = ConvertFrom-Json (gh issue list -s all -L $limit -R $repo --json 'author,number,createdAt,closedAt,updatedAt,state,title,url')
    $result = ConvertFrom-Json (gh issue list -s all -L $limit -R $repo --json 'number,state,createdAt,closedAt,title')

    foreach ($item in $result) {
        [PSCustomObject][Ordered] @{
            # repo    = $repo
            # author  = $item.author.login
            number  = $item.number
            created = $item.createdAt
            # updated = $item.updatedAt
            closed  = !$item.closedAt ? [datetime]::MinValue : $item.closedAt
            # closed  = $item.closedAt  
            state   = $item.state
            title   = $item.title
            # url     = $item.url
        }
    }
}

$xlparams = @{
    AutoFilter    = $true
    AutoNameRange = $true
    AutoSize      = $true
    Path          = './ghissues.xlsx'
    TableName     = 'ghIssues'
    WorksheetName = 'ghIssues'
}

$repo = 'dfinke/importexcel'
Remove-Item ./ghissues.xlsx -ErrorAction silentlycontinue

$xlpkg = Get-GHIssues $repo -limit 100 | Export-Excel @xlparams -PassThru
$ws = $xlpkg.ghIssues

$pivotTableParams = @{
    PivotTableName  = "State"
    Address         = $ws.cells["G2"]
    SourceWorkSheet = $ws
    PivotRows       = @('state', 'created')
    PivotData       = @{'state' = 'count' }
    PivotTableStyle = 'Light21'
    GroupDateRow    = 'created'
    GroupDatePart   = @('Years', 'Quarters', 'Month')
}

$pt = Add-PivotTable @pivotTableParams -PassThru
$pt.RowHeaderCaption = "By Date Created"

$pivotTableParams.PivotTableName = "StateByClosed"
$pivotTableParams.Address = $ws.cells["G22"]
$pivotTableParams.PivotRows = @('state', 'closed')
$pivotTableParams.GroupDateRow = 'closed'

$pt = Add-PivotTable @pivotTableParams -PassThru
$pt.RowHeaderCaption = "By Date Closed"

Close-ExcelPackage -ExcelPackage $xlpkg -Show