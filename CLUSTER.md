# WSL2 – Creare 2 istanze Debian separate

Questa guida descrive una procedura **riproducibile e funzionante** per creare **due istanze Debian indipendenti** su **Windows tramite WSL2**, chiarendo limiti e comportamenti reali della piattaforma.

---

## 1. Prerequisiti

- Windows 10 / 11 aggiornato
- PowerShell eseguito come **Amministratore**
- Connessione Internet

---

## 2. Installare o aggiornare WSL2

Aprire PowerShell come amministratore ed eseguire:

```powershell
wsl --install
wsl --update
wsl --status
````

Verificare che la versione predefinita sia **WSL 2**.

---

## 3. Ottenere un rootfs Debian affidabile (metodo consigliato)

Il metodo più affidabile per ottenere un root filesystem Debian compatibile con WSL è:

1. installare la **Debian ufficiale per WSL**
2. esportarla in un file `.tar`
3. riutilizzare quel tar per creare più istanze

Questo evita problemi legati a rootfs incompleti o non compatibili.

---

### 3.1 Installare Debian ufficiale su WSL

```powershell
wsl --install -d Debian
```

Al primo avvio Debian richiederà la creazione di un utente iniziale
(es. `temp`). Questo utente verrà usato solo per l’export.

Verifica:

```powershell
wsl -l -v
```

---

### 3.2 Esportare Debian in un file tar

```powershell
mkdir C:\wsl\exports
wsl --export Debian C:\wsl\exports\debian-rootfs.tar
```

Il file `debian-rootfs.tar` è ora pronto per essere importato più volte.

Fonte ufficiale Microsoft:
[https://learn.microsoft.com/en-us/windows/wsl/install](https://learn.microsoft.com/en-us/windows/wsl/install)

---

## 4. Importare due istanze Debian separate

Creare le directory di destinazione:

```powershell
mkdir C:\wsl\debian1
mkdir C:\wsl\debian2
```

Importare le due distro:

```powershell
wsl --import Debian1 C:\wsl\debian1 C:\wsl\exports\debian-rootfs.tar --version 2
wsl --import Debian2 C:\wsl\debian2 C:\wsl\exports\debian-rootfs.tar --version 2
```

Verifica:

```powershell
wsl -l -v
```

---

## 5. Configurare le risorse globali WSL2

Creare o modificare il file:

```
C:\Users\<TUO_UTENTE>\.wslconfig
```

Contenuto consigliato:

```ini
[wsl2]
memory=4GB
processors=2
localhostForwarding=true
```

**Nota importante**

* Le risorse sono **globali per tutte le distro WSL**
* Non è possibile assegnare CPU o RAM per singola istanza

Applicare la configurazione:

```powershell
wsl --shutdown
```

---

## 6. Creare l’utente `user` con privilegi sudo

> I rootfs importati **non includono `sudo`** per default.

### Debian1

```powershell
wsl -d Debian1
```

```bash
apt update
apt install -y sudo

adduser user
usermod -aG sudo user

exit
```

### Debian2

```powershell
wsl -d Debian2
```

```bash
apt update
apt install -y sudo

adduser user
usermod -aG sudo user

exit
```

La password viene impostata **interattivamente**.

---

## 7. Impostare `user` come utente di default

### Debian1

```powershell
wsl -d Debian1 --user root
```

```bash
printf "[user]\ndefault=user\n" > /etc/wsl.conf
exit
```

### Debian2

```powershell
wsl -d Debian2 --user root
```

```bash
printf "[user]\ndefault=user\n" > /etc/wsl.conf
exit
```

Applicare:

```powershell
wsl --shutdown
```

---

## 8. Spazio disco (VHDX): comportamento reale

* Ogni distro usa un **VHDX dinamico**
* Il disco cresce automaticamente al bisogno
* **Non è possibile fissare un limite reale (es. 30 GB)** come in Hyper-V

Operazioni utili:

* Verifica spazio: `df -h`
* Pulizia: `apt clean`
* Riduzione: export/import

Per dischi a dimensione fissa → **Hyper-V**

---

## 9. Rete tra le due distro

* Le distro WSL2 sono su rete NAT virtuale
* Possono comunicare tra loro tramite IP privati

Verifica IP:

```bash
ip addr
```

Limitazioni:

* Nessuna rete “internal / host-only” nativa
* Nessun isolamento di rete avanzato

Per networking strutturato → Hyper-V / VMware / VirtualBox

---

## 10. Comandi utili

Elenco distro:

```powershell
wsl -l -v
```

Accesso a una distro:

```powershell
wsl -d Debian1
```

Spegnere WSL:

```powershell
wsl --shutdown
```

Export / Import:

```powershell
wsl --export Debian1 C:\wsl\exports\debian1.tar
wsl --import Debian1Copy C:\wsl\debian1copy C:\wsl\exports\debian1.tar --version 2
```

---

## 11. Limiti strutturali di WSL2

* CPU e RAM configurabili solo **globalmente**
* Disco **dinamico**
* Networking semplificato (NAT)

Per VM complete con isolamento e risorse garantite → **Hyper-V**

```

---

Se vuoi, nel prossimo passo posso:
- prepararti una **README GitHub-ready** con badge e TOC
- oppure convertirla in **runbook aziendale / lab didattico**
- oppure affiancarla a una **versione Hyper-V equivalente**
