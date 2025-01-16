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

# Valikkofunktio
function Show-Menu {
    Write-Host "Valitse toiminto:"
    Write-Host "1. Pakkaa tiedostot"
    Write-Host "2. Palauta tiedostot"
    Write-Host "0. Poistu"
    return Read-Host "Syötä valinta (0-2)"
}

# Pakkaustoiminto
function Compress-Files {
    Write-Host "Valitse lähdekansio tiedostojen pakkaamista varten:"
    $sourceFolder = Select-Folder
    if (-not $sourceFolder) {
        Write-Host "Lähdekansiota ei valittu. Palataan valikkoon."
        return
    }

    Write-Host "Valitse tallennuskansio:"
    $destinationFolder = Select-Folder
    if (-not $destinationFolder) {
        Write-Host "Tallennuskansiota ei valittu. Palataan valikkoon."
        return
    }

    Get-ChildItem -Path $sourceFolder -Recurse -File | ForEach-Object {
        $relativePath = $_.FullName.Substring($sourceFolder.Length).TrimStart("\\")
        $targetPath = Join-Path -Path $destinationFolder -ChildPath $relativePath
        $targetDir = Split-Path -Path $targetPath -Parent

        if (-not (Test-Path -Path $targetDir)) {
            New-Item -ItemType Directory -Path $targetDir | Out-Null
        }

        $zipFile = \"$targetPath.zip\"
        Compress-Archive -Path $_.FullName -DestinationPath $zipFile -Force
        Write-Host "Pakattiin: $_.FullName -> $zipFile"
    }

    Write-Host "Kaikki tiedostot on pakattu ja tallennettu kansioon: $destinationFolder"
}

# Palautustoiminto
function Restore-Files {
    Write-Host "Valitse tallennuskansio (jossa ZIP-tiedostot sijaitsevat):"
    $destinationFolder = Select-Folder
    if (-not $destinationFolder) {
        Write-Host "Tallennuskansiota ei valittu. Palataan valikkoon."
        return
    }

    Write-Host "Valitse kohdekansio palautusta varten:"
    $restoreFolder = Select-Folder
    if (-not $restoreFolder) {
        Write-Host "Palautuskansiota ei valittu. Palataan valikkoon."
        return
    }

    Get-ChildItem -Path $destinationFolder -Recurse -File -Filter *.zip | ForEach-Object {
        $relativePath = $_.FullName.Substring($destinationFolder.Length).TrimStart("\\")
        $originalFilePath = $relativePath.Substring(0, $relativePath.Length - 4) # Poistetaan .zip
        $targetPath = Join-Path -Path $restoreFolder -ChildPath $originalFilePath
        $targetDir = Split-Path -Path $targetPath -Parent

        if (-not (Test-Path -Path $targetDir)) {
            New-Item -ItemType Directory -Path $targetDir | Out-Null
        }

        Expand-Archive -Path $_.FullName -DestinationPath $targetDir -Force
        Write-Host "Purettu: $_.FullName -> $targetDir"
    }

    Write-Host "Kaikki tiedostot on palautettu kohteeseen: $restoreFolder"
}

# Pääohjelma
while ($true) {
    Clear-Host
    $choice = Show-Menu
    switch ($choice) {
        "1" { Compress-Files }
        "2" { Restore-Files }
        "0" { Write-Host "Ohjelma suljetaan."; break }
        default { Write-Host "Virheellinen valinta, yritä uudelleen." }
    }

    Write-Host "Paina Enter jatkaaksesi..."
    Read-Host
}
