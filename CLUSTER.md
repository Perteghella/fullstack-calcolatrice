# WSL2 – Creare 2 istanze Debian separate (procedura funzionante)

Questa procedura permette di creare **due istanze Debian indipendenti** su **Windows con WSL2**, includendo i file necessari e i passaggi corretti.

---

## 1) Prerequisiti

- Windows 10 / 11 aggiornato
- PowerShell eseguito come **Amministratore**
- Connessione Internet

---

## 2) Installare o aggiornare WSL2

Aprire PowerShell come amministratore ed eseguire:

```powershell
wsl --install
wsl --update
wsl --status
````

Verificare che la versione predefinita sia **WSL 2**.

---

Hai centrato il punto: **lo step 3 “scarica un rootfs da debuerreotype” spesso non funziona in pratica** perché:

* è facile scaricare **il file sbagliato** (branch/arch non corretta, formato diverso, ecc.)
* quei tarball sono pensati per Docker e possono mancare di alcune “comodità” (non è un problema grave, ma complica)
* soprattutto: **manca un metodo riproducibile “one-click”** per ottenere *quel* tarball corretto

La correzione più robusta (e che funziona sempre) è: **installi Debian ufficiale via WSL** e poi **cloni** la distro con `--export`/`--import`.

Sotto ti lascio **solo lo Step 3 corretto** (più lo Step 4 aggiornato di conseguenza), in Markdown “raw”:

````markdown
## 3) Ottenere un rootfs Debian “sicuro” (metodo consigliato: install + export)

Invece di scaricare tarball da terze parti, usa la Debian ufficiale per WSL e poi esportala come tar.
Questo evita file mancanti / formati sbagliati e rende la procedura riproducibile.

### 3.1 Installare Debian ufficiale su WSL (una sola volta)

Apri PowerShell come amministratore:

```powershell
wsl --install -d Debian
````

Al primo avvio Debian ti chiederà di creare un utente. Puoi usare un utente temporaneo (es. `temp`) perché poi verrà solo esportata.

Verifica che Debian sia presente:

```powershell
wsl -l -v
```

### 3.2 Esportare Debian in un tar (rootfs)

Crea una cartella export e fai l’export:

```powershell
mkdir C:\wsl\exports
wsl --export Debian C:\wsl\exports\debian-rootfs.tar
```

> Nota: il file esportato è un tar valido per `wsl --import`.

Fonti Microsoft su installazione e import/export: ([Microsoft Learn][1])

---

## 4) Importare 2 istanze Debian separate (da quel tar)

Ora puoi creare due istanze indipendenti usando lo stesso tar esportato:

```powershell
mkdir C:\wsl\debian1
mkdir C:\wsl\debian2

wsl --import Debian1 C:\wsl\debian1 C:\wsl\exports\debian-rootfs.tar --version 2
wsl --import Debian2 C:\wsl\debian2 C:\wsl\exports\debian-rootfs.tar --version 2
```

Verifica:

```powershell
wsl -l -v
```


### Perché questa è la correzione giusta
- usi una **distro Debian ufficiale WSL**
- ottieni un tar sicuramente importabile
- elimini del tutto il problema “quale rootfs scarico e da dove”

Se vuoi, ti integro questa correzione dentro **il file unico completo** (tutta la procedura finale) mantenendo sempre Markdown “raw”, senza render.
::contentReference[oaicite:1]{index=1}
```

[1]: https://learn.microsoft.com/en-us/windows/wsl/install?utm_source=chatgpt.com "How to install Linux on Windows with WSL"

---

## 5) Configurare risorse globali WSL2

Creare o modificare il file:

* `C:\Users\<TUO_UTENTE>\.wslconfig`

Contenuto consigliato:

```ini
[wsl2]
memory=4GB
processors=2
localhostForwarding=true
```

**Nota importante:**

* Le risorse sono **globali per tutte le distro**
* Non è possibile assegnare memoria o CPU per singola distro tramite `.wslconfig`

Applicare la configurazione:

```powershell
wsl --shutdown
```

---

## 6) Creare l’utente `user` con privilegi sudo (in entrambe le distro)

> Nota: i rootfs importati spesso **non includono `sudo`**. Per questo si installa prima.

### Debian1

Aprire la shell:

```powershell
wsl -d Debian1
```

Dentro Debian:

```bash
apt update
apt install -y sudo

adduser user
usermod -aG sudo user

exit
```

### Debian2

Aprire la shell:

```powershell
wsl -d Debian2
```

Dentro Debian:

```bash
apt update
apt install -y sudo

adduser user
usermod -aG sudo user

exit
```

La password viene impostata **interattivamente** durante `adduser`.

---

## 7) Impostare `user` come utente di default (in entrambe le distro)

### Debian1

Entrare come root:

```powershell
wsl -d Debian1 --user root
```

Impostare il default user tramite `/etc/wsl.conf`:

```bash
printf "[user]\ndefault=user\n" > /etc/wsl.conf
exit
```

### Debian2

Entrare come root:

```powershell
wsl -d Debian2 --user root
```

Impostare il default user:

```bash
printf "[user]\ndefault=user\n" > /etc/wsl.conf
exit
```

Applicare:

```powershell
wsl --shutdown
```

Verifica: aprendo `wsl -d Debian1` dovresti entrare direttamente come `user`.

---

## 8) Spazio disco (VHDX): comportamento reale

* WSL2 usa un file **VHDX dinamico** per ogni distro
* Il VHDX cresce automaticamente al bisogno
* **Non è possibile fissare un limite reale a 30 GB** in modo “nativo” come una VM Hyper-V

Operazioni utili:

* Controllo spazio: `df -h`
* Pulizia: `apt clean`
* Riduzione/ricompattazione tipicamente richiede procedure di export/import o strumenti specifici

Se servono dischi “fissi” o limiti rigidi → valutare **Hyper-V**.

---

## 9) Rete tra le due distro

* Le distro WSL2 sono in rete NAT (virtuale) e possono comunicare tra loro tramite IP privati
* Per vedere l’IP dentro ogni distro:

```bash
ip addr
```

Limitazioni:

* Non c’è un meccanismo semplice “host-only/internal” isolato tra sole distro
* Per isolamento di rete reale → Hyper-V / VMware / VirtualBox

---

## 10) Comandi utili

Elenco distro:

```powershell
wsl -l -v
```

Accedere a una distro:

```powershell
wsl -d Debian1
```

Spegnere WSL (applica `.wslconfig` e riavvia ambiente):

```powershell
wsl --shutdown
```

Export / Import:

```powershell
mkdir C:\wsl\exports

wsl --export Debian1 C:\wsl\exports\debian1.tar
wsl --import Debian1Copy C:\wsl\debian1copy C:\wsl\exports\debian1.tar --version 2
```

---

## 11) Limiti strutturali di WSL2 (da sapere)

* Risorse (CPU/RAM) configurabili solo **globalmente**
* Disco **dinamico** (non “fisso” come VM classiche)
* Networking semplificato (NAT), niente isolamento interno “facile”

Per VM “vere” con isolamento e risorse garantite → **Hyper-V**
