
$ErrorActionPreference = "Stop"

$sourceUrl = "https://www.geil.to/live/catalog/live/channels.json?&&filter%5Bgroup%5D=Portugal"

$catalogFile = Join-Path $PSScriptRoot "..\catalog\live\portugal.json"
$itemDirectory = Join-Path $PSScriptRoot "..\item\live"

Write-Host "Downloading Portuguese channels..."

$response = Invoke-RestMethod -Uri $sourceUrl -Method Get

if ($response -is [System.Array]) {
    $channels = @($response)
} else {
    $channels = @($response.items)
}

if ($channels.Count -eq 0) {
    throw "No channels received."
}

New-Item -ItemType Directory -Force -Path (Split-Path $catalogFile) | Out-Null
New-Item -ItemType Directory -Force -Path $itemDirectory | Out-Null

$catalogItems = @()

foreach ($channel in $channels) {

    $id = [string]$channel.id
    if ([string]::IsNullOrWhiteSpace($id)) { continue }

    $name = [string]$channel.name
    $playUrl = "https://geil.to/live/play/$id"

    $item = @{
        id = $id
        name = $name
        type = "live"
        tags = @("Portugal")
        sources = @(
            @{
                url = $playUrl
                name = "geil.to"
            }
        )
    }

    if ($channel.images -and $channel.images.logo) {
        $logo = [string]$channel.images.logo

        if ($logo.StartsWith("/")) {
            $logo = "https://www.geil.to$logo"
        }

        $item.images = @{
            logo = $logo
        }
    }

    if ($channel.epg) {
        $item.epg = @($channel.epg)
    }

    # Save individual item
    $itemJson = ConvertTo-Json -InputObject $item -Depth 40

    [System.IO.File]::WriteAllText(
        (Join-Path $itemDirectory "$id.json"),
        $itemJson,
        [System.Text.UTF8Encoding]::new($false)
    )

    # Add the same item to the catalogue
    $catalogItems += $item
}

$catalog = @{
    items = $catalogItems
    nextCursor = $null
}

$catalogJson = ConvertTo-Json -InputObject $catalog -Depth 40

[System.IO.File]::WriteAllText(
    $catalogFile,
    $catalogJson,
    [System.Text.UTF8Encoding]::new($false)
)

Write-Host ""
Write-Host "BUILD COMPLETE"
Write-Host "Channels: $($catalogItems.Count)"
Write-Host "Individual items: $itemDirectory"
Write-Host "Catalogue: $catalogFile"
