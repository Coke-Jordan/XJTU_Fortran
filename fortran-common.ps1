Set-StrictMode -Version 3.0

function Set-ConsoleUtf8 {
    $utf8 = [System.Text.UTF8Encoding]::new($false)
    [Console]::InputEncoding = $utf8
    [Console]::OutputEncoding = $utf8
    $script:OutputEncoding = $utf8
    & chcp.com 65001 | Out-Null
}

function Get-FortranCompilerArguments {
    return @(
        '-std=f2018',
        '-Wall',
        '-Wextra',
        '-g',
        '-fdiagnostics-color=always'
    )
}

function Get-FortranSourceInfo {
    param(
        [Parameter(Mandatory = $true)]
        [string]$SourceFile
    )

    $sourcePath = (Resolve-Path -LiteralPath $SourceFile).Path
    $sourceDir = Split-Path -Parent $sourcePath
    $sourceName = Split-Path -Leaf $sourcePath
    $programName = [System.IO.Path]::GetFileNameWithoutExtension($sourceName) + '.exe'
    $programPath = Join-Path $sourceDir $programName

    return [pscustomobject]@{
        SourcePath  = $sourcePath
        SourceDir   = $sourceDir
        SourceName  = $sourceName
        ProgramName = $programName
        ProgramPath = $programPath
    }
}
