[CmdletBinding()]
param(
    [string]$ZomboidHome = (Join-Path $env:USERPROFILE 'Zomboid')
)

$ErrorActionPreference = 'Stop'

$projectRoot = Split-Path -Parent $PSScriptRoot
$sourceMod = Join-Path $projectRoot 'src\MorningCall'
$repoItem = Join-Path $projectRoot 'workshop\MorningCall'
$repoContent = Join-Path $repoItem 'Contents\mods\MorningCall'
$userWorkshopRoot = Join-Path $ZomboidHome 'Workshop'
$userItem = Join-Path $userWorkshopRoot 'MorningCall'
$userContent = Join-Path $userItem 'Contents\mods\MorningCall'
$repoWorkshopTxt = Join-Path $repoItem 'workshop.txt'
$userWorkshopTxt = Join-Path $userItem 'workshop.txt'
$releaseDirectory = Join-Path $projectRoot 'release'
$releaseZip = Join-Path $releaseDirectory 'MorningCall-B42.21.zip'

function Assert-ManagedPath {
    param(
        [Parameter(Mandatory)] [string]$Path,
        [Parameter(Mandatory)] [string]$AllowedParent,
        [Parameter(Mandatory)] [string]$ExpectedLeaf
    )

    $fullPath = [IO.Path]::GetFullPath($Path)
    $fullParent = [IO.Path]::GetFullPath($AllowedParent).TrimEnd('\') + '\'
    if (-not $fullPath.StartsWith($fullParent, [StringComparison]::OrdinalIgnoreCase)) {
        throw "Refusing to manage path outside '$fullParent': $fullPath"
    }
    if ((Split-Path -Leaf $fullPath) -ne $ExpectedLeaf) {
        throw "Refusing to manage unexpected directory: $fullPath"
    }
    return $fullPath
}

function Reset-ManagedDirectory {
    param(
        [Parameter(Mandatory)] [string]$Path,
        [Parameter(Mandatory)] [string]$AllowedParent,
        [Parameter(Mandatory)] [string]$ExpectedLeaf
    )

    $safePath = Assert-ManagedPath -Path $Path -AllowedParent $AllowedParent -ExpectedLeaf $ExpectedLeaf
    if (Test-Path -LiteralPath $safePath) {
        Remove-Item -LiteralPath $safePath -Recurse -Force
    }
    New-Item -ItemType Directory -Path $safePath -Force | Out-Null
}

if (-not (Test-Path -LiteralPath (Join-Path $sourceMod '42\mod.info'))) {
    throw "Canonical source is missing 42\mod.info: $sourceMod"
}
if (-not (Test-Path -LiteralPath $repoWorkshopTxt)) {
    throw "Workshop metadata is missing: $repoItem\workshop.txt"
}
if (-not (Test-Path -LiteralPath (Join-Path $repoItem 'preview.png'))) {
    throw "Workshop preview is missing: $repoItem\preview.png"
}

# If the game has assigned an ID in the uploader copy, preserve it in the
# repository metadata before refreshing the package. This prevents a later
# build from accidentally turning an update into a second Workshop item.
$repoMetadata = Get-Content -Raw -LiteralPath $repoWorkshopTxt
$repoId = if ($repoMetadata -match '(?m)^id=(\d+)\s*$') { $Matches[1] } else { $null }
if (-not $repoId -and (Test-Path -LiteralPath $userWorkshopTxt)) {
    $userMetadata = Get-Content -Raw -LiteralPath $userWorkshopTxt
    if ($userMetadata -match '(?m)^id=(\d+)\s*$') {
        $repoId = $Matches[1]
        $repoMetadata = [Regex]::Replace($repoMetadata, '(?m)^id=.*$', "id=$repoId")
        Set-Content -LiteralPath $repoWorkshopTxt -Value $repoMetadata -Encoding utf8NoBOM -NoNewline
        Write-Host "Preserved Workshop ID $repoId in repository metadata."
    }
}

# Refresh only the two exact MorningCall content directories.
$repoModsParent = Join-Path $repoItem 'Contents\mods'
New-Item -ItemType Directory -Path $repoModsParent -Force | Out-Null
Reset-ManagedDirectory -Path $repoContent -AllowedParent $repoModsParent -ExpectedLeaf 'MorningCall'
Copy-Item -Path (Join-Path $sourceMod '*') -Destination $repoContent -Recurse -Force

New-Item -ItemType Directory -Path $userWorkshopRoot -Force | Out-Null
Reset-ManagedDirectory -Path $userItem -AllowedParent $userWorkshopRoot -ExpectedLeaf 'MorningCall'
Copy-Item -LiteralPath $repoWorkshopTxt -Destination $userItem
Copy-Item -LiteralPath (Join-Path $repoItem 'preview.png') -Destination $userItem
New-Item -ItemType Directory -Path (Split-Path -Parent $userContent) -Force | Out-Null
Copy-Item -LiteralPath $repoContent -Destination (Split-Path -Parent $userContent) -Recurse -Force

New-Item -ItemType Directory -Path $releaseDirectory -Force | Out-Null
if (Test-Path -LiteralPath $releaseZip) {
    Remove-Item -LiteralPath $releaseZip -Force
}
Compress-Archive -LiteralPath $sourceMod -DestinationPath $releaseZip -CompressionLevel Optimal

Write-Host "Repository Workshop package: $repoItem"
Write-Host "Game uploader package:       $userItem"
Write-Host "Manual distribution ZIP:     $releaseZip"
