<# configure_wslconfig.ps1
Crea/aggiorna il file %USERPROFILE%\.wslconfig con i parametri richiesti
Usage: .\configure_wslconfig.ps1 -Memory 4GB -Processors 2 -LocalhostForwarding $true
#>
param(
  [string]$Memory = "4GB",
  [int]$Processors = 2,
  [bool]$LocalhostForwarding = $true
)
$conf = "[wsl2]`nmemory=$Memory`nprocessors=$Processors`nlocalhostForwarding=$LocalhostForwarding`n"
$out = Join-Path $env:USERPROFILE ".wslconfig"
$conf | Out-File -FilePath $out -Encoding ascii -Force
Write-Host "Wrote $out"
Write-Host "Esegui 'wsl --shutdown' per applicare la nuova configurazione"