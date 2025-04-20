function Get-StardewModsPath {
    # Unidades montadas no sistema
    $drives = Get-PSDrive -PSProvider FileSystem

    # Caminhos possíveis (Program Files e Program Files (x86))
    $steamPaths = @(
        "Program Files\Steam\steamapps\common\Stardew Valley\Mods",
        "Program Files (x86)\Steam\steamapps\common\Stardew Valley\Mods"
    )

    foreach ($drive in $drives) {
        foreach ($path in $steamPaths) {
            $fullPath = Join-Path $drive.Root $path
            if (Test-Path $fullPath) {
                return $fullPath
            }
        }
    }

    return $null
}

function Get-DownloadsPath {
    try {
        $downloads = [Environment]::GetFolderPath("Downloads")
        if (-not (Test-Path $downloads)) {
            throw
        }
        return $downloads
    } catch {
        $fallback = Join-Path $env:USERPROFILE 'Downloads'
        if (Test-Path $fallback) {
            Write-Host "Usando caminho alternativo para Downloads: $fallback"
            return $fallback
        } else {
            throw "Não foi possível localizar a pasta de Downloads."
        }
    }
}

function DownloadAndExtractMod {
    $downloadUrl = "https://github.com/hi-bernardo/stardew-mods/releases/download/v1/stardew_mods.zip"
    $downloadsPath = Get-DownloadsPath
    $zipFilePath = Join-Path $downloadsPath "stardew_mods.zip"

    Write-Host "Baixando mod para: $zipFilePath"
    Invoke-WebRequest -Uri $downloadUrl -OutFile $zipFilePath

    $modPath = Get-StardewModsPath

    if ($modPath) {
        Write-Host "Pasta 'Mods' localizada em: $modPath"
        $userChoice = Read-Host "Deseja sobrescrever o conteúdo da pasta Mods? (S/N)"
        
        if ($userChoice -eq "S") {
            Write-Host "Limpando conteúdo da pasta Mods..."
            Remove-Item "$modPath\*" -Recurse -Force

            Write-Host "Extraindo mod para: $modPath"
            Expand-Archive -Path $zipFilePath -DestinationPath $modPath -Force
            Write-Host "Mod extraído com sucesso para $modPath!"
        } else {
            $newPath = Join-Path $downloadsPath "stardew_mods"
            Write-Host "Extraindo mod para pasta alternativa: $newPath"
            Expand-Archive -Path $zipFilePath -DestinationPath $newPath -Force
        }
    } else {
        Write-Host "Não foi possível localizar a pasta Mods automaticamente."
        $fallbackPath = Join-Path $downloadsPath "stardew_mods"
        Write-Host "Extraindo mod para pasta alternativa: $fallbackPath"
        Expand-Archive -Path $zipFilePath -DestinationPath $fallbackPath -Force
    }
}

DownloadAndExtractMod
