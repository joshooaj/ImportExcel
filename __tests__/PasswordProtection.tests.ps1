﻿Describe "Password Support" -Skip:($PSVersionTable.PSVersion.Major -gt 5) {
    Context "Password protected sheet" {
        BeforeAll  {
            $password = "YouMustRememberThis"
            $path = "TestDrive:\Test.xlsx"
            Remove-Item $path -ErrorAction SilentlyContinue
            Get-Service | Select-Object -First 10 | Export-excel -password $password -Path $Path -DisplayPropertySet
        }
        it "Threw an error when the password was omitted                                           " {
            {Open-ExcelPackage -Path $path }                     | Should      -Throw
        }
        it "Was able to append when the password was included                                      " {
            {Get-Service | Select-Object -First 10 |
                Export-excel -password $password -Path $Path -Append }  | Should -Not -Throw
        }
        it "Kept the password on the file when it was saved                                        " {
            {Import-Excel $Path }                                       | Should      -Throw
        }
        it "Could read the file when the password was included                                     " {
            (Import-excel $path -Password $password).count              | Should      -Be 20
        }
    }
}
