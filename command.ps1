# URL do ZIP no GitHub Releases
$zipUrl = "https://github.com/hi-bernardo/stardew-mods/releases/download/v1/stardew_mods.zip"

# Caminho temporário pro ZIP
$zipPath = "$PWD\stardew_mods.zip"

# Baixar o ZIP
Invoke-WebRequest -Uri $zipUrl -OutFile $zipPath

# Extrair o ZIP na pasta atual
Expand-Archive -Path $zipPath -DestinationPath $PWD -Force

# Deletar o ZIP após extração
Remove-Item $zipPath
