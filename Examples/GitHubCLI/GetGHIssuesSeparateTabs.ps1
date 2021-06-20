function Get-GHIssues {
    param (
        [Parameter(Mandatory)]
        $repo,
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
    AutoFilter    = $true
    AutoSize      = $true
    Path          = './ghissues.xlsx'    
    WorksheetName = 'name'
    TableName     = 'tableName'
}

Remove-Item ./ghissues.xlsx -ErrorAction silentlycontinue
$repos = 'dfinke/importexcel', 'RandomFractals/vscode-snippets-viewer', 'powershell/powershell'

foreach ($targetRepo in $repos) {
    $owner, $name = $targetRepo.split("/")
    
    $xlparams.WorksheetName = $name
    $xlparams.TableName = "{0}Issues" -f $name

    Get-GHIssues $targetRepo -limit 100  | Export-Excel @xlparams 
}

Invoke-Item './ghissues.xlsx'