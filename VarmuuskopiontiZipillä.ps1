Add-Type -AssemblyName System.Windows.Forms

# Tyhjennä PowerShell-ikkuna
Clear-Host

Write-Host "Valitse kansiot ja ohjelma aloittaa pakkaamisen."

function Select-FolderDialog {
    param (
        [string]$Description = "Valitse kansio",
        [string]$RootFolder = "MyComputer"
    )
    [System.Windows.Forms.Application]::EnableVisualStyles()
    $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    $folderBrowser.Description = $Description
    $folderBrowser.RootFolder = $RootFolder

    if ($folderBrowser.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        return $folderBrowser.SelectedPath
    }
    return $null
}

# Valitse kansio, joka zipataan
$sourceFolder = Select-FolderDialog -Description "Valitse kansio, joka zipataan"

if ($sourceFolder) {
    # Valitse tallennuskansio
    $destinationFolder = Select-FolderDialog -Description "Valitse tallennuskansio"

    if ($destinationFolder) {
        Write-Host -ForegroundColor "yellow" "Aloitetaan kansion pakkaus"
        # Määritä zip-tiedoston nimi
        $zipFileName = [System.IO.Path]::Combine($destinationFolder, "$(Split-Path $sourceFolder -Leaf).zip")

        # Luo zip-tiedosto
        Add-Type -AssemblyName "System.IO.Compression.FileSystem"
        [System.IO.Compression.ZipFile]::CreateFromDirectory($sourceFolder, $zipFileName)
        
        Write-Host -ForegroundColor "green" "Kansio '$sourceFolder' pakattiin onnistuneesti tiedostoon '$zipFileName'."
    } else {
        Write-Host -ForegroundColor "red" "Tallennuskansiota ei valittu."
    }
} else {
    Write-Host -ForegroundColor "red" "Kansiota ei valittu."
}

Start-Sleep -Seconds 5

# Määritä tiedoston polku
$filePath = [System.IO.Path]::Combine($sourceFolder, $zipFileName)
# Hae nykyinen päivämäärä ja aika
$currentDateTime = Get-Date -Format "yyyyMMdd_HHmmss"

# Erota tiedoston nimi ja laajennus
$fileName = [System.IO.Path]::GetFileNameWithoutExtension($filePath)
$fileExtension = [System.IO.Path]::GetExtension($filePath)
$fileDirectory = [System.IO.Path]::GetDirectoryName($filePath)

# Luo uusi tiedoston nimi aikaleimalla
$newFileName = "{0}_{1}{2}" -f $fileName, $currentDateTime, $fileExtension
$newFilePath = [System.IO.Path]::Combine($fileDirectory, $newFileName)

# Uudelleennimeä tiedosto
Rename-Item -Path $filePath -NewName $newFileName

# Tyhjennä PowerShell-ikkuna
Clear-Host

Write-Host "Tiedosto nimetty uudelleen: $newFilePath"
Write-Host ""
Read-Host -Prompt "Paina Enter sulkeaksesi ikkunan"
