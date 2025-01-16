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

# Valitse tallennuskansio
$destinationFolder = Select-FolderDialog -Description "Valitse tallennuskansio"

# Funktio, joka pakkaa tiedoston tai kansion
function Compress-Item {
    param (
        [string]$itemPath,
        [string]$destinationPath
    )
    $zipFileName = "$destinationPath\$((Get-Item $itemPath).BaseName).zip"
    Compress-Archive -Path $itemPath -DestinationPath $zipFileName
}

# Käy läpi kaikki tiedostot ja alikansiot lähdekansiossa
$items = Get-ChildItem -Path $sourceFolder -Recurse

foreach ($item in $items) {
    if ($item.PSIsContainer) {
        # Jos kohde on kansio, pakkaa se
        Compress-Item -itemPath $item.FullName -destinationPath $destinationFolder
    } else {
        # Jos kohde on tiedosto, pakkaa se
        Compress-Item -itemPath $item.FullName -destinationPath $destinationFolder
    }
}

Write-Output "Kaikki tiedostot ja alikansiot on pakattu erikseen ZIP-tiedostoiksi."
Write-Host ""
Read-Host -Prompt "Paina Enter sulkeaksesi ikkunan"
