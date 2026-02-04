## WSL2 — Creare 2 istanze Debian e configurare risorse

Queste istruzioni sono per Windows con WSL2. WSL2 è leggero e integrato in Windows, ma ha limitazioni: le risorse (CPU, memoria) si configurano globalmente in `~/.wslconfig` e la rete è NAT verso l'host (non esiste facilmente una rete "internal" isolata fra distro). Se vuoi VM con risorse garantite e rete interna, prendi in considerazione Hyper‑V.

### 1) Prerequisiti
- Windows 10/11 (preferibilmente aggiornato)
- PowerShell eseguito come amministratore
- Connessione internet per scaricare immagini

### 2) Installare/aggiornare WSL2
Apri PowerShell come amministratore ed esegui:

```powershell
wsl --install
wsl --update
wsl --status
```

Se vuoi installare direttamente Debian fornito da Microsoft Store puoi usare:

```powershell
wsl --install -d Debian
```

### 3) Creare due distro Debian separate (import da tarball)
Scarica un rootfs o una cloud image Debian (tar.gz). Poi importa due istanze:

```powershell
mkdir C:\wsl\images
# salva qui debian-rootfs.tar.gz

# importa due distro
wsl --import Debian1 C:\wsl\debian1 C:\wsl\images\debian-rootfs.tar.gz --version 2
wsl --import Debian2 C:\wsl\debian2 C:\wsl\images\debian-rootfs.tar.gz --version 2
```

In alternativa puoi installare una sola Debian dal Microsoft Store e clonare con `wsl --export`/`--import`.

### 4) Configurare risorse globali (memoria/processori)
Crea o edita `C:\Users\<TUO_UTENTE>\.wslconfig` con:

```
[wsl2]
memory=4GB
processors=2
localhostForwarding=true
```

Questa configurazione è globale per tutte le distro; riavvia WSL per applicarla:

```powershell
wsl --shutdown
```

Nota: se imposti `memory=4GB` e `processors=2` questo è il limite globale: non è possibile dare 4GB a ciascuna distro separatamente tramite `.wslconfig`.

### 5) Creare l'utente `user` con password `Pa$$w0rd` in ogni distro

```powershell
wsl -d Debian1
# dentro la shell Debian1
adduser --gecos "" user
echo 'user:Pa$$w0rd' | sudo chpasswd
usermod -aG sudo user
exit

wsl -d Debian2
# dentro la shell Debian2
adduser --gecos "" user
echo 'user:Pa$$w0rd' | sudo chpasswd
usermod -aG sudo user
exit
```

### 6) Spazio disco (VHDX) — come ottenere ~30GB
Il filesystem WSL2 usa un file VHDX dinamico nella cartella della distro (es. `%USERPROFILE%\\AppData\\Local\\Packages\\...` o la cartella che hai scelto durante `--import`). Per avere un VHDX di ~30GB puoi:

- Esportare la distro, creare un VHDX nuovo di dimensione fissa e reimportare; esempio (procedura sintetica):

```powershell
# esporta
wsl --export Debian1 C:\wsl\exports\debian1.tar
# crea VHDX con Hyper-V tools (PowerShell) o usa diskpart per creare un VHD/VHDX
# poi importa specificando la cartella con il VHDX creato
wsl --import Debian1 C:\wsl\debian1 C:\wsl\exports\debian1.tar --version 2
```

Per semplicità, è spesso più pratico usare Hyper‑V se hai bisogno di dischi a dimensione fissa esatta.

### 7) Rete e comunicazione tra le due distro
- Le distro WSL2 condividono la stessa rete virtuale NAT verso l'host. Possono comunicare tra loro tramite gli IP privati assegnati dal motore WSL (usa `ip addr` dentro ogni distro per vedere l'IP). L'host può raggiungerle via `localhost` (se `localhostForwarding=true`).
- Non esiste un modo nativo semplice per creare una rete "internal" isolata solo fra le distro in WSL2; per questo usare Hyper‑V o VirtualBox è preferibile se serve isolamento di rete.

### 8) Esempi utili di comandi

- Lista distro e stato:

```powershell
wsl -l -v
```

- Accedere alla shell di una distro:

```powershell
wsl -d Debian1
```

- Esportare/Importare una distro:

```powershell
wsl --export Debian1 C:\wsl\exports\debian1.tar
wsl --import Debian1Back C:\wsl\debian1back C:\wsl\exports\debian1.tar --version 2
```

### 9) Cosa non è possibile (limiti)
- Non puoi assegnare 4GB *per ogni distro* tramite `.wslconfig` (è un limite globale). Se vuoi risorse garantite per VM separate, usa Hyper‑V.
- Non esiste una semplice rete host-only isolata tra sola due distro WSL2.

---

Se vuoi, procedo ad aggiungere la procedura Hyper‑V completa nel file, o genero script PowerShell per automatizzare l'import/installazione. Fammi sapere quale preferisci.

