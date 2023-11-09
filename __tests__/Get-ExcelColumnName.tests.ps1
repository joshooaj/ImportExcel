Describe "Get-ExcelColumnName" {
    BeforeDiscovery {
        $script:map = @(
            @{ Number = 26; Name = 'Z' },
            @{ Number = 27; Name = 'AA' },
            @{ Number = 28; Name = 'AB' },
            @{ Number = 30; Name = 'AD' },
            @{ Number = 48; Name = 'AV' },
            @{ Number = 1024; Name = 'AMJ' },
            @{ Number = 2048; Name = 'BZT' },
            @{ Number = 3072; Name = 'DND' },
            @{ Number = 4096; Name = 'FAN' },
            @{ Number = 5120; Name = 'GNX' },
            @{ Number = 6144; Name = 'IBH' },
            @{ Number = 7168; Name = 'JOR' },
            @{ Number = 8192; Name = 'LCB' },
            @{ Number = 9216; Name = 'MPL' },
            @{ Number = 10240; Name = 'OCV' },
            @{ Number = 11264; Name = 'PQF' },
            @{ Number = 12288; Name = 'RDP' },
            @{ Number = 13312; Name = 'SQZ' },
            @{ Number = 14336; Name = 'UEJ' },
            @{ Number = 15360; Name = 'VRT' },
            @{ Number = 16384; Name = 'XFD' }
        )
    }
    
    It 'Column <number> maps to "<name>"' -ForEach $map {
        (Get-ExcelColumnName $Number).ColumnName | Should -Be $Name
    }
}
