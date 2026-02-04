````markdown
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

## 3) Scaricare un rootfs Debian compatibile con WSL

È necessario un **root filesystem (tar.gz) compatibile con WSL**. Un repository comunemente usato per ottenere rootfs Debian “puliti” è:

[https://github.com/debuerreotype/docker-debian-artifacts](https://github.com/debuerreotype/docker-debian-artifacts)

Scaricare un file del tipo:

* `debian-12-amd64.tar.gz`

Salvare il file in:

* `C:\wsl\images\`

Esempio:

* `C:\wsl\images\debian-12-amd64.tar.gz`

---

## 4) Importare 2 istanze Debian separate

Creare le directory di destinazione:

```powershell
mkdir C:\wsl\images
mkdir C:\wsl\debian1
mkdir C:\wsl\debian2
```

Importare le due distro:

```powershell
wsl --import Debian1 C:\wsl\debian1 C:\wsl\images\debian-12-amd64.tar.gz --version 2
wsl --import Debian2 C:\wsl\debian2 C:\wsl\images\debian-12-amd64.tar.gz --version 2
```

Verifica:

```powershell
wsl -l -v
```

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
