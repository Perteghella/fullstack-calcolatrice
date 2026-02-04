<# resize_vhdx.ps1
Esegue export e import per ricreare la distro in una nuova cartella (per ottenere un nuovo VHDX di dimensione adeguata)
NOTA: WSL usa VHDX dinamici; non c'è un'opzione pubblica per forzare un VHDX fixed-size direttamente. Questo script esporta la distro, la reimporta in una nuova cartella e rimuove quella vecchia se richiesto.
Uso:
  .\resize_vhdx.ps1 -DistroName Debian1 -NewInstallPath C:\wsl\debian1_new -TempExport C:\wsl\exports\debian1_temp.tar -RemoveOld $true
#>
param(
  [Parameter(Mandatory=$true)] [string]$DistroName,
  [Parameter(Mandatory=$true)] [string]$NewInstallPath,
  [Parameter(Mandatory=$true)] [string]$TempExport,
  [switch]$RemoveOld = $false
)

if (Test-Path $NewInstallPath) { Write-Error "NewInstallPath già esistente: $NewInstallPath"; exit 1 }

Write-Host "Export della distro $DistroName in $TempExport (potrebbe richiedere tempo)..."
wsl --export $DistroName $TempExport

Write-Host "Unregistering $DistroName (non perderai i dati perché abbiamo l'export)..."
wsl --unregister $DistroName

Write-Host "Import in $NewInstallPath"
wsl --import $DistroName $NewInstallPath $TempExport --version 2

if ($RemoveOld) {
  Write-Host "Rimuovere eventuale vecchia cartella manualmente (non presente perché abbiamo unregister)."
}

Write-Host "Operazione completata. Esegui 'wsl --shutdown' per assicurarti che le modifiche siano applicate."