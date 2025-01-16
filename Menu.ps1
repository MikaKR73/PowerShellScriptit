# Funktio, joka näyttää valikon
function Show-Menu {
    Clear-Host
    Write-Host "Valitse toiminto:"
    Write-Host "1. Suorita skripti 1"
    Write-Host "2. Suorita skripti 2"
    Write-Host "0. Poistu"
    return Read-Host "Syötä valinta (0-2)"
}

# Funktio toisen skriptin suorittamiseen
function Execute-Script {
    param (
        [string]$ScriptPath
    )
    if (Test-Path $ScriptPath) {
        Write-Host "Suoritetaan skripti: $ScriptPath"
        & $ScriptPath
    } else {
        Write-Host "Skriptitiedostoa ei löydy: $ScriptPath"
    }
}

# Pääohjelma
while ($true) {
    $choice = Show-Menu
    switch ($choice) {
        "1" {
            # Kutsu ensimmäistä skriptiä
            $script1Path = "C:\\polku\\skriptiin1.ps1"
            Execute-Script -ScriptPath $script1Path
        }
        "2" {
            # Kutsu toista skriptiä
            $script2Path = "C:\\polku\\skriptiin2.ps1"
            Execute-Script -ScriptPath $script2Path
        }
        "0" {
            Write-Host "Ohjelma suljetaan."
            Write-Host " "
            Write-Host "Paina Enter jatkaaksesi..."
            exit
        }
        default {
            Write-Host "Virheellinen valinta, yritä uudelleen."
        }
    }

    Write-Host "Paina Enter jatkaaksesi..."
    Read-Host
}
