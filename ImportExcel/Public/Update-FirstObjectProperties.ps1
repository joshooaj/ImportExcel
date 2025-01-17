function Update-FirstObjectProperties {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification='Does not change system state')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '', Justification='Property would be incorrect')]
    [CmdletBinding()]
    param   (
        [Parameter(ValueFromPipeline=$true)]
        $InputObject
    )
    begin   {   $union = New-Object -TypeName System.Collections.ArrayList }
    process {
        try {
            If ($union.Count -eq 0)  {
                [void]$union.Add($InputObject)
                $memberNames = (Get-Member -InputObject $InputObject -MemberType Properties).Name
            }
            else {
                foreach ($propName in (Get-Member -InputObject $InputObject -MemberType Properties).Name) {
                    if  ($propName -notin $memberNames) {
                        Add-Member -InputObject $Union[0] -MemberType NoteProperty -Name $propName -Value $Null
                        $memberNames += $propName
                    }
                }
                [void]$Union.Add($InputObject)
            }
        }
        catch {throw "Failed updating the properties of the first object: $_"}
    }
    end     {   $Union   }
}