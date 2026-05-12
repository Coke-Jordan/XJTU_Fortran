[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$SourceFile
)

$ErrorActionPreference = 'Stop'

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
. (Join-Path $scriptDir 'fortran-common.ps1')

Set-ConsoleUtf8

function Test-IsModuleSource {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    $content = Get-Content -LiteralPath $Path -Raw -Encoding UTF8
    $hasModule = $content -match '(?im)^\s*module\s+[a-z_][a-z0-9_]*'
    $hasProgram = $content -match '(?im)^\s*program\s+[a-z_][a-z0-9_]*'
    return ($hasModule -and -not $hasProgram)
}

function Get-DefinedModuleNames {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    $content = Get-Content -LiteralPath $Path -Raw -Encoding UTF8
    return [regex]::Matches($content, '(?im)^\s*module\s+([a-z_][a-z0-9_]*)') |
        ForEach-Object { $_.Groups[1].Value.ToLowerInvariant() }
}

function Get-UsedModuleNames {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    $modules = @()
    foreach ($line in Get-Content -LiteralPath $Path -Encoding UTF8) {
        $trimmed = $line.Trim()
        if ($trimmed -notmatch '^(?i)use\b') {
            continue
        }

        $rest = $trimmed -replace '^(?i)use\s*', ''
        $rest = $rest -replace '^(?i),\s*(intrinsic|non_intrinsic)\s*', ''
        $rest = $rest -replace '^(?i)::\s*', ''
        $moduleName = ($rest -split ',')[0].Trim().ToLowerInvariant()
        if ($moduleName) {
            $modules += $moduleName
        }
    }

    return $modules | Select-Object -Unique
}

function Resolve-ModuleDependencies {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path,
        [Parameter(Mandatory = $true)]
        [hashtable]$ModuleSourceMap,
        [System.Collections.Generic.HashSet[string]]$VisitedFiles
    )

    $resolved = New-Object System.Collections.Generic.List[string]
    foreach ($moduleName in Get-UsedModuleNames -Path $Path) {
        if (-not $ModuleSourceMap.ContainsKey($moduleName)) {
            continue
        }

        $moduleFile = $ModuleSourceMap[$moduleName]
        if ($VisitedFiles.Contains($moduleFile)) {
            continue
        }

        [void]$VisitedFiles.Add($moduleFile)
        foreach ($dependency in Resolve-ModuleDependencies -Path $moduleFile -ModuleSourceMap $ModuleSourceMap -VisitedFiles $VisitedFiles) {
            $resolved.Add($dependency)
        }
        $resolved.Add($moduleFile)
    }

    return $resolved
}

function Test-FileWritableForLink {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    if (-not (Test-Path -LiteralPath $Path)) {
        return $true
    }

    try {
        $stream = [System.IO.File]::Open($Path, [System.IO.FileMode]::Open, [System.IO.FileAccess]::ReadWrite, [System.IO.FileShare]::None)
        $stream.Close()
        return $true
    }
    catch {
        return $false
    }
}

$sourceInfo = Get-FortranSourceInfo -SourceFile $SourceFile
$sourcePath = $sourceInfo.SourcePath
$sourceDir = $sourceInfo.SourceDir
$sourceName = $sourceInfo.SourceName
$programName = $sourceInfo.ProgramName
$programPath = $sourceInfo.ProgramPath
$compilerArguments = Get-FortranCompilerArguments

if (Test-IsModuleSource -Path $sourcePath) {
    throw "Please build a program source such as Q2.f90 or Q3.f90, not a module source."
}

Push-Location -LiteralPath $sourceDir
try {
    $moduleSourceMap = @{}
    Get-ChildItem -LiteralPath . -Filter '*.f90' |
        Where-Object { Test-IsModuleSource -Path $_.FullName } |
        ForEach-Object {
            foreach ($moduleName in Get-DefinedModuleNames -Path $_.FullName) {
                $moduleSourceMap[$moduleName] = $_.Name
            }
        }

    $visitedFiles = New-Object 'System.Collections.Generic.HashSet[string]'
    $moduleFiles = Resolve-ModuleDependencies -Path $sourcePath -ModuleSourceMap $moduleSourceMap -VisitedFiles $visitedFiles

    foreach ($moduleFile in $moduleFiles) {
        & gfortran @compilerArguments -J . -c $moduleFile
        if ($LASTEXITCODE -ne 0) {
            exit $LASTEXITCODE
        }
    }

    $objectFiles = $moduleFiles |
        ForEach-Object { [System.IO.Path]::GetFileNameWithoutExtension($_) + '.o' }

    $arguments = @()
    $arguments += $compilerArguments
    $arguments += $objectFiles
    $arguments += $sourceName
    $arguments += @('-o', $programName)

    if (-not (Test-FileWritableForLink -Path $programPath)) {
        throw "Cannot write $programName. Close the previous run or debugger session, then build again."
    }

    & gfortran @arguments
    if ($LASTEXITCODE -ne 0) {
        exit $LASTEXITCODE
    }
}
finally {
    Pop-Location
}
