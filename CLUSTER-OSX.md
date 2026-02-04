# CLUSTER OSX (Apple Silicon M1)

Questo documento mostra come creare 2 VM Debian ARM64 su macOS (Apple Silicon, es. M1) usando Multipass. Le VM saranno configurate con 2 CPU, 4GB RAM, 30GB disco e con un utente `user` con password `Pa$$w0rd`.

> Nota: assicurati di usare immagini ARM64 (aarch64) compatibili con Apple Silicon.

## 1) Installare Multipass

```bash
brew install --cask multipass
# oppure scarica il .pkg da https://multipass.run
```

## 2) Creare cloud-init per creare l'utente

Salva questo file come `user-data.yaml`:

```yaml
#cloud-config
users:
  - name: user
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash
chpasswd:
  list: |
    user:Pa$$w0rd
  expire: False
ssh_pwauth: True
```

Questo abilita l'utente `user` con password `Pa$$w0rd` e sudo senza password.

## 3) Ottenere un'immagine Debian ARM64

Cerca un'immagine cloud Debian ARM64 su https://cloud.debian.org/images/ e copia l'URL dell'immagine arm64 (cloud image o rootfs). Useremo `https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-generic-arm64.qcow2` come segnaposto.

Esempio rapido: molte distribuzioni forniscono immagini cloud compatibili con Multipass; se fornisci l'URL posso inserirlo nei comandi.

## 4) Creare le 2 VM (2 CPU, 4GB, 30GB)

```bash
# esempio con immagine Debian 12 (bookworm) ARM64
multipass launch --name debian1 --cpus 2 --mem 4G --disk 30G --cloud-init user-data.yaml https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-generic-arm64.qcow2
multipass launch --name debian2 --cpus 2 --mem 4G --disk 30G --cloud-init user-data.yaml https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-generic-arm64.qcow2
```

Multipass scaricherà e avvierà le istanze. Se l'immagine non è specificata, Multipass userà la sua immagine predefinita per la release richiesta.

## 5) Verificare stato e ottenere IP

```bash
multipass list
multipass info debian1
multipass info debian2
```

Per connettersi:

```bash
multipass shell debian1
# o
ssh user@<IP>   # se SSH password abilitata
```

## 6) Rete tra le VM

Le VM Multipass sono su una rete NAT condivisa: possono comunicare tra loro tramite IP privati mostrati da `multipass info`. Per una rete "internal" isolata (host-only) Multipass non fornisce direttamente questa modalità; in tal caso considera UTM (QEMU) o VirtualBox (se disponibile), che consentono switch host-only.

## 7) Alternative e note

- Verifica sempre che l'immagine sia ARM64/aarch64 per Apple Silicon.
- Se preferisci GUI e controllo fine della rete, usa UTM o VirtualBox con rete host-only.
- Se vuoi, posso cercare e inserire l'URL esatto dell'immagine Debian arm64 e generare i comandi finali.

## 8) Comandi utili riassunto

```bash
# installa multipass
brew install --cask multipass

# crea le VM (sostituisci IMAGE_URL)
multipass launch --name debian1 --cpus 2 --mem 4G --disk 30G --cloud-init user-data.yaml <IMAGE_URL_ARM64>
multipass launch --name debian2 --cpus 2 --mem 4G --disk 30G --cloud-init user-data.yaml <IMAGE_URL_ARM64>

# lista e info
multipass list
multipass info debian1

# shell
multipass shell debian1
```

---

Se vuoi, cerco l'URL dell'immagine Debian ARM64 e aggiorno i comandi con l'URL reale oppure genero un breve script che automatizza tutto (download immagine + multipass launch).