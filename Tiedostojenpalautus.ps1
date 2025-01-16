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

# Valitse tallennuskansio, josta palautetaan
Write-Host "Valitse tallennuskansio (jossa ZIP-tiedostot sijaitsevat):"
$destinationFolder = Select-Folder
if (-not $destinationFolder) {
    Write-Host -ForegroundColor "red" "Tallennuskansiota ei valittu. Lopetetaan."
      Write-Host ""
    Read-Host -Prompt "Paina Enter sulkeaksesi ikkunan"
    exit
}

# Tyhjennä PowerShell-ikkuna
cls

# Valitse palautuksen kohdekansio (alkuperäinen lähdekansio)
Write-Host "Valitse kohdekansio palautusta varten:"
$restoreFolder = Select-Folder
if (-not $restoreFolder) {
    Write-Host -ForegroundColor "red" "Palautuskansiota ei valittu. Lopetetaan."
      Write-Host ""
    Read-Host -Prompt "Paina Enter sulkeaksesi ikkunan"
    exit
}

# Tyhjennä PowerShell-ikkuna
cls

# Puretaan ZIP-tiedostot ja palautetaan alkuperäinen kansiorakenne
Get-ChildItem -Path $destinationFolder -Recurse -File -Filter *.zip | ForEach-Object {
    $relativePath = $_.FullName.Substring($destinationFolder.Length).TrimStart("\\")
    $originalFilePath = $relativePath.Substring(0, $relativePath.Length - 4) # Poistetaan .zip
    $targetPath = Join-Path -Path $restoreFolder -ChildPath $originalFilePath
    $targetDir = Split-Path -Path $targetPath -Parent

    if (-not (Test-Path -Path $targetDir)) {
        New-Item -ItemType Directory -Path $targetDir | Out-Null
    }

    Expand-Archive -Path $_.FullName -DestinationPath $targetDir -Force
    Write-Host -ForegroundColor "yellow" "Purettu: $_.FullName -> $targetDir"
}

Write-Host ""
Write-Host -ForegroundColor "green" "Kaikki tiedostot on palautettu kohteeseen: $restoreFolder"
Write-Host ""
Read-Host -Prompt "Paina Enter sulkeaksesi ikkunan"
