# wsl2-debian-noninteractive 🔧

Set di script per creare automaticamente istanze Debian non-interattive in WSL2.

## Prerequisiti

- Windows 10/11 con WSL2 installato
- PowerShell eseguito come Amministratore per l'import
- Un `debian-rootfs.tar` valido (esportato da una Debian WSL ufficiale)

## Uso rapido (esempio)

1. Copia il tuo `debian-rootfs.tar` in una posizione accessibile (es. `C:\wsl\exports\debian-rootfs.tar`).
2. (Opzionale) Configura le risorse globali:

```powershell
.\configure_wslconfig.ps1 -Memory 4GB -Processors 2 -LocalhostForwarding $true
wsl --shutdown
```

3. Importa le distro e crea l'utente non-interattivo (`user` / `PA$$w0rd`):

```powershell
.\import_distro.ps1 -RootfsTar C:\wsl\exports\debian-rootfs.tar -DistroNames Debian1,Debian2 -User user -Password 'PA$$w0rd' -Ram '4GB' -Cpus 2 -DiskGB 30
```

4. Dopo l'import, esegui `wsl --shutdown` e avvia le distro: `wsl -d Debian1`.

## Note tecniche

- WSL usa `.wslconfig` a livello utente per impostare memoria e CPU (non per singola distro).
- Per avere un VHDX "nuovo" con maggiore spazio si può usare `resize_vhdx.ps1` che usa export/import per ricreare la distro.
- Mettere la tar in `templates/` è sconsigliato nel repo (troppo grande): usa percorsi esterni e riferiscili nello script.

---

Per dettagli e modalità avanzate, leggi i file in `scripts/` e `docs/CLUSTER.md`.