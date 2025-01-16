# Tyhjennä PowerShell-ikkuna
cls

Add-Type -AssemblyName System.Windows.Forms

# Funktio kansiovalintaa varten
function Select-Folder {
    $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    if ($folderBrowser.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        return $folderBrowser.SelectedPath
    } else {
        return $null
    }
}

# Valitse lähdekansio
Write-Host "Valitse lähdekansio:"
$sourceFolder = Select-Folder
if (-not $sourceFolder) {
    Write-Host -ForegroundColor "red" "Lähdekansiota ei valittu. Lopetetaan."
    Write-Host ""
    Read-Host -Prompt "Paina Enter sulkeaksesi ikkunan"
    exit
}

# Tyhjennä PowerShell-ikkuna
cls

# Valitse tallennuskansio
Write-Host "Valitse tallennuskansio:"
$destinationFolder = Select-Folder
if (-not $destinationFolder) {
    Write-Host -ForegroundColor "red" "Tallennuskansiota ei valittu. Lopetetaan."
    Write-Host ""
    Read-Host -Prompt "Paina Enter sulkeaksesi ikkunan"
    exit
}

# Tyhjennä PowerShell-ikkuna
cls

# Luo alikansiot uudelleen tallennuskansioon ja pakkaa tiedostot
Get-ChildItem -Path $sourceFolder -Recurse -File | ForEach-Object {
    $relativePath = $_.FullName.Substring($sourceFolder.Length).TrimStart("\\")
    $targetPath = Join-Path -Path $destinationFolder -ChildPath $relativePath
    $targetDir = Split-Path -Path $targetPath -Parent

    if (-not (Test-Path -Path $targetDir)) {
        New-Item -ItemType Directory -Path $targetDir | Out-Null
    }

    $zipFile = "$targetPath.zip"
    Compress-Archive -Path $_.FullName -DestinationPath $zipFile -Force
    Write-Host -ForegroundColor "yellow" "Pakattiin: $_.FullName -> $zipFile"
}

Write-Host ""
Write-Host  -ForegroundColor "green" "Kaikki tiedostot on pakattu ja tallennettu kansioon: $destinationFolder"
Write-Host ""
Read-Host -Prompt "Paina Enter sulkeaksesi ikkunan"