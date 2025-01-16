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
	
# Hae kaikki tiedostot lähdekansiosta
$files = Get-ChildItem -Path $sourceFolder -File

# Pakkaa jokainen tiedosto erikseen
foreach ($file in $files) {
    $zipFileName = "$destinationFolder\$($file.BaseName).zip"
	write-host  -ForegroundColor "yellow" "pakataan: "$zipFileName
    Compress-Archive -Path $file.FullName -DestinationPath $zipFileName
}

Write-Output "Kaikki tiedostot on pakattu erikseen ZIP-tiedostoiksi."
Write-Host ""
Read-Host -Prompt "Paina Enter sulkeaksesi ikkunan"
