[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$SourceFile
)

$ErrorActionPreference = 'Stop'

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
. (Join-Path $scriptDir 'fortran-common.ps1')
$buildScript = Join-Path $scriptDir 'build-fortran.ps1'

Set-ConsoleUtf8

& $buildScript $SourceFile
if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
}

$sourceInfo = Get-FortranSourceInfo -SourceFile $SourceFile
$sourceDir = $sourceInfo.SourceDir
$programName = $sourceInfo.ProgramName
$programPath = $sourceInfo.ProgramPath

if (-not (Test-Path -LiteralPath $programPath)) {
    throw "Build succeeded but $programName was not found."
}

Push-Location -LiteralPath $sourceDir
try {
    & $programPath
}
finally {
    Pop-Location
}
