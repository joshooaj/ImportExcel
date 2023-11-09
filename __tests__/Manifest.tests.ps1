param(
    # Specifies the path to ImportExcel.psd1. If omitted, it will default to
    # the "pre-compiled" version at "./ImportExcel/ImportExcel.psd1". During a
    # CI workflow, the path should always be to a freshly-built copy at
    # "./Output/ImportExcel/<version/ImportExcel.psd1" - the "./build.ps1"
    # script provides this path after a successful build.
    [Parameter()]
    [string]
    $ModulePath
)

BeforeDiscovery {
    if ([string]::IsNullOrEmpty($ModulePath)) {
        $basePath = if ($PSScriptRoot) { $PSScriptRoot } else { $PWD.Path }
        $ModulePath = (Resolve-Path -Path (Join-Path -Path $basePath -ChildPath '../ImportExcel/ImportExcel.psd1')).Path
    }
    Import-Module $ModulePath -Force -ErrorAction Stop
    $script:ImportExcelModulePath = $ModulePath
}

BeforeAll {
    if ([string]::IsNullOrEmpty($ModulePath)) {
        $basePath = if ($PSScriptRoot) { $PSScriptRoot } else { $PWD.Path }
        $ModulePath = (Resolve-Path -Path (Join-Path -Path $basePath -ChildPath '../ImportExcel/ImportExcel.psd1')).Path
    }
    Import-Module $ModulePath -Force -ErrorAction Stop
    $script:ImportExcelModulePath = $ModulePath
}

Describe 'Module manifest' {
    BeforeAll {
        $script:manifestData = Test-ModuleManifest -Path $ImportExcelModulePath -ErrorAction Stop -Verbose:$false -WarningAction SilentlyContinue
        $script:moduleFolder = ([io.fileinfo]$ImportExcelModulePath).DirectoryName
    }

    Context 'Validation' {
        It 'Has a valid manifest' {
            $manifestData | Should -Not -BeNullOrEmpty
        }

        It 'Has a valid name in the manifest' {
            $manifestData.Name | Should -Be 'ImportExcel'
        }

        It 'Has a valid root module' {
            $manifestData.RootModule | Should -Be "ImportExcel.psm1"
        }

        It 'Has a valid version in the manifest' {
            $manifestData.Version -as [Version] | Should -Not -BeNullOrEmpty
        }

        It 'Has a valid description' {
            $manifestData.Description | Should -Not -BeNullOrEmpty
        }

        It 'Has a valid author' {
            $manifestData.Author | Should -Not -BeNullOrEmpty
        }

        It 'Has a valid guid' {
            {[guid]::Parse($manifestData.Guid)} | Should -Not -Throw
        }

        It 'Has a valid copyright' {
            $manifestData.CopyRight | Should -Not -BeNullOrEmpty
        }

        It 'Has all files declared in FileList' {
            foreach ($file in $manifestData.FileList) {
                $file | Should -Exist
            }
        }
    }
}