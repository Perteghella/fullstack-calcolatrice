<#
.import_distro.ps1
PowerShell script per importare una tar rootfs in 2 distro WSL, creare l'utente non-interattivo e applicare .wslconfig
Esempio:
  .\import_distro.ps1 -RootfsTar C:\wsl\exports\debian-rootfs.tar -DistroNames Debian1,Debian2 -User user -Password 'PA$$w0rd' -Ram '4GB' -Cpus 2 -DiskGB 30
#>
param(
  [Parameter(Mandatory=$true)] [string]$RootfsTar,
  [Parameter(Mandatory=$true)] [string[]]$DistroNames,
  [string]$User = "user",
  [string]$Password = "PA$$w0rd",
  [string]$Ram = "4GB",
  [int]$Cpus = 2,
  [int]$DiskGB = 30,
  [string]$ExportDir = "C:\wsl\exports",
  [string]$InstallBase = "C:\wsl\distros"
)

function Ensure-Path([string]$p){ if (-not (Test-Path $p)) { New-Item -ItemType Directory -Force -Path $p | Out-Null } }

if (-not (Test-Path $RootfsTar)) { Write-Error "Rootfs tar non trovato: $RootfsTar"; exit 1 }

Ensure-Path $ExportDir
Ensure-Path $InstallBase

Write-Host "Scrivo .wslconfig globale con memory=$Ram processors=$Cpus e localhostForwarding=true"
$wslConf = @"[wsl2]
memory=$Ram
processors=$Cpus
localhostForwarding=true
"@
$envUserProfile = $env:USERPROFILE
$globalWslConfigPath = Join-Path $envUserProfile ".wslconfig"
$wslConf | Out-File -FilePath $globalWslConfigPath -Encoding ascii -Force
Write-Host "Applica la configurazione eseguendo: wsl --shutdown"

foreach ($name in $DistroNames) {
  $installPath = Join-Path $InstallBase $name
  if (Test-Path $installPath) { Write-Host "Path $installPath già esistente, verrà rimosso e ricreato"; Remove-Item -Recurse -Force $installPath }
  New-Item -ItemType Directory -Force -Path $installPath | Out-Null

  Write-Host "Importando $name da $RootfsTar in $installPath..."
  wsl --import $name $installPath $RootfsTar --version 2

  Write-Host "Creazione utente $User in $name"
  wsl -d $name -- bash -lc "useradd -m -s /bin/bash $User || true"
  wsl -d $name -- bash -lc "echo '$User:$Password' | chpasswd"
  wsl -d $name -- bash -lc "apt-get update && apt-get install -y sudo || true"
  wsl -d $name -- bash -lc "usermod -aG sudo $User || true"

  # Imposta user come default nella distro
  Write-Host "Imposto $User come utente di default in /etc/wsl.conf"
  wsl -d $name -- bash -lc "printf '[user]\ndefault=$User\n' > /etc/wsl.conf"

  Write-Host "Eseguire 'wsl --shutdown' per applicare .wslconfig e riavviare le distro" 
}

Write-Host "Import completato. Si consiglia: wsl --shutdown"