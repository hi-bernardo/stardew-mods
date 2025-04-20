# URL do ZIP no GitHub Releases
$zipUrl = "https://github.com/hi-bernardo/stardew-mods/releases/download/v1/stardew_mods.zip"

# Caminho temporário para o ZIP
$zipPath = "$PWD\stardew_mods.zip"

# Baixar o ZIP
Invoke-WebRequest -Uri $zipUrl -OutFile $zipPath

# Caminho padrão para o diretório de Mods no Steam (Stardew Valley)
$steamModsDir = "$env:ProgramFiles(x86)\Steam\steamapps\common\Stardew Valley\Mods"

# Verificar se a pasta Mods existe
if (Test-Path $steamModsDir) {
    # Se a pasta existir, perguntar ao usuário se está correta
    $response = Read-Host "A pasta de Mods foi encontrada no caminho padrão: $steamModsDir. Deseja usar essa pasta? (S/N)"
    
    if ($response -eq 'S') {
        # Apagar conteúdo da pasta antes de extrair
        Write-Host "Apagando os arquivos existentes na pasta..."
        Remove-Item "$steamModsDir\*" -Recurse -Force

        # Extrair o arquivo ZIP na pasta de Mods
        Expand-Archive -Path $zipPath -DestinationPath $steamModsDir -Force
        Write-Host "Conteúdo extraído com sucesso em: $steamModsDir"
    } else {
        # Se o usuário não confirmar, criar nova pasta no Downloads
        $downloadsDir = [System.IO.Path]::Combine($env:USERPROFILE, 'Downloads', 'stardew_mods')
        Write-Host "Extrair para a pasta: $downloadsDir"
        
        # Extrair o ZIP para a pasta no Downloads
        Expand-Archive -Path $zipPath -DestinationPath $downloadsDir -Force
        Write-Host "Conteúdo extraído com sucesso em: $downloadsDir"
    }
} else {
    # Caso a pasta de Mods não exista, perguntar onde o usuário deseja extrair
    $response = Read-Host "A pasta de Mods não foi encontrada no caminho padrão. Deseja selecionar outro diretório para extração? (S/N)"
    
    if ($response -eq 'S') {
        # Solicitar ao usuário o caminho para a pasta
        $selectedPath = Read-Host "Por favor, insira o caminho completo para a pasta desejada"
        
        if (Test-Path $selectedPath) {
            # Apagar conteúdo da pasta, caso exista
            Write-Host "Apagando os arquivos existentes na pasta..."
            Remove-Item "$selectedPath\*" -Recurse -Force

            # Extrair o arquivo ZIP no diretório escolhido
            Expand-Archive -Path $zipPath -DestinationPath $selectedPath -Force
            Write-Host "Conteúdo extraído com sucesso em: $selectedPath"
        } else {
            Write-Host "O caminho fornecido não existe. Nenhuma ação será realizada."
        }
    } else {
        # Se o usuário não desejar alterar o diretório, extrair na pasta Downloads
        $downloadsDir = [System.IO.Path]::Combine($env:USERPROFILE, 'Downloads', 'stardew_mods')
        Write-Host "Extrair para a pasta: $downloadsDir"
        
        # Extrair o ZIP para a pasta no Downloads
        Expand-Archive -Path $zipPath -DestinationPath $downloadsDir -Force
        Write-Host "Conteúdo extraído com sucesso em: $downloadsDir"
    }
}

# Remover o arquivo ZIP após extração
Remove-Item $zipPath
